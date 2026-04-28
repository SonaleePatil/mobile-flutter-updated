import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final bool enableLogging;
  final int maxRetries;
  final Duration retryDelay;

  ApiInterceptor({
    this.enableLogging = kDebugMode,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshQueue = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
    final accessToken = await TokenStorageService.getAccessToken();



final isRefreshApi = options.path.contains("/v1/auth/refresh");

if (!isRefreshApi) {
  if (accessToken != null && accessToken.isNotEmpty) {
    options.headers['Authorization'] = "Bearer $accessToken";

  } else {

  }
}

print(" Headers: ${options.headers}");
      options.headers['Content-Type'] =
          options.headers['Content-Type'] ?? 'application/json';
      options.headers['Accept'] =
          options.headers['Accept'] ?? 'application/json';

      handler.next(options);
    } catch (_) {
      handler.next(options);
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {


handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final response = await _handle401(err);

      if (response != null) {
        handler.resolve(response);
        return;
      }
    }

    if (_shouldRetry(err)) {
      final response = await _retryRequest(err.requestOptions);
      if (response != null) {
        handler.resolve(response);
        return;
      }
    }

    handler.next(err);
  }

  Future<Response?> _handle401(DioException err) async {
    final requestOptions = err.requestOptions;

    if (requestOptions.path.contains("/v1/auth/refresh")) {
      await TokenStorageService.clearTokens();
      return null;
    }

    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshQueue.add(completer);

      final newAccessToken = await completer.future;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return null;
      }

      return _retryWithNewToken(requestOptions, newAccessToken);
    }

    _isRefreshing = true;

    try {
      final newAccessToken = await _refreshAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await TokenStorageService.clearTokens();
        _notifyRefreshQueue(null);
        return null;
      }

      _notifyRefreshQueue(newAccessToken);

      return _retryWithNewToken(requestOptions, newAccessToken);
    } catch (_) {
      await TokenStorageService.clearTokens();
      _notifyRefreshQueue(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: "https://adcc-b4f3.onrender.com",
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      final response = await dio.post(
        "/v1/auth/refresh",
        data: {
          "refreshToken": refreshToken,
        },
      );

      final body = response.data;

      if (body is Map<String, dynamic>) {
        final data = body["data"];

        if (data is Map<String, dynamic>) {
          final newAccessToken = data["accessToken"] as String?;
          final newRefreshToken = data["refreshToken"] as String?;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await TokenStorageService.saveAccessToken(newAccessToken);
          }

          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await TokenStorageService.saveRefreshToken(newRefreshToken);
          }

          return newAccessToken;
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Response?> _retryWithNewToken(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    try {
      requestOptions.headers["Authorization"] =
          "Bearer $newAccessToken";

      final dio = Dio(
        BaseOptions(
          baseUrl: requestOptions.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      final response = await dio.fetch(requestOptions);
      return response;
    } catch (_) {
      return null;
    }
  }

  void _notifyRefreshQueue(String? token) {
    for (final completer in _refreshQueue) {
      if (!completer.isCompleted) {
        completer.complete(token);
      }
    }
    _refreshQueue.clear();
  }

  Future<Response?> _retryRequest(
    RequestOptions requestOptions,
  ) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await Future.delayed(
            retryDelay * (retryCount + 1));

        final dio = Dio(
          BaseOptions(
            baseUrl: requestOptions.baseUrl,
            connectTimeout:
                const Duration(seconds: 60),
            receiveTimeout:
                const Duration(seconds: 60),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            validateStatus: (status) =>
                status != null &&
                status >= 200 &&
                status < 300,
          ),
        );

        final response = await dio.fetch(requestOptions);
        return response;
      } catch (_) {
        retryCount++;
      }
    }

    return null;
  }

  bool _shouldRetry(DioException err) {
    return err.type ==
            DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type ==
            DioExceptionType.receiveTimeout ||
        err.type ==
            DioExceptionType.connectionError;
  }
}