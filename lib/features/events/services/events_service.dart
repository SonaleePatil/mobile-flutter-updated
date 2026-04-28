import 'package:adcc/features/events/Model/model_events.dart';
import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_exception.dart';
import '../../../core/services/api_response.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/token_storage_service.dart';

class EventsService {
  final _apiClient = ApiClient.instance;

  Future<ApiResponse<List<Event>>> getEvents({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.events,
        queryParameters: queryParameters,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        try {
          List<dynamic> eventsData = [];

          if (response.data is List) {
            eventsData = response.data as List<dynamic>;
          } else if (response.data is Map) {
            final data = response.data as Map<String, dynamic>;

            if (data['data'] != null && data['data'] is Map) {
              final nestedData = data['data'] as Map<String, dynamic>;
              eventsData = nestedData['events'] as List<dynamic>? ?? [];
            } else if (data['events'] != null && data['events'] is List) {
              eventsData = data['events'] as List<dynamic>;
            } else if (data['data'] != null && data['data'] is List) {
              eventsData = data['data'] as List<dynamic>;
            }
          }

          final events = eventsData
              .map((json) {
                try {
                  return Event.fromJson(json as Map<String, dynamic>);
                } catch (_) {
                  return null;
                }
              })
              .whereType<Event>()
              .toList();

          if (events.isEmpty) {
            return ApiResponse.error(
              message: 'No events parsed from response',
              statusCode: response.statusCode,
            );
          }

          return ApiResponse.success(
            data: events,
            statusCode: response.statusCode,
          );
        } catch (e) {
          return ApiResponse.error(
            message: 'Failed to parse events data: $e',
            statusCode: response.statusCode,
          );
        }
      }

      return ApiResponse.error(
        message: 'Failed to fetch events',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<ApiResponse<dynamic>> joinEvent({
    required String eventId,
  }) async {
    try {
      String? userId = await TokenStorageService.getUserId();
      userId ??= "69959a9430e2025c6208df05";

      final body = {
        "eventId": eventId,
        "userId": userId,
        "status": "joined",
      };

      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.joinEvent(eventId),
        data: body,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
          message: response.data["message"] ?? "Registered successfully",
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to register",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: "Unexpected error: $e");
    }
  }

  Future<ApiResponse<dynamic>> cancelEvent({
    required String eventId,
    required String reason,
  }) async {
    try {
      String? userId = await TokenStorageService.getUserId();
      userId ??= "69959a9430e2025c6208df05";

      final body = {
        "eventId": eventId,
        "userId": userId,
        "status": "cancelled",
        "reason": reason,
      };

      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.cancelEvent(eventId),
        data: body,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
          message: response.data["message"] ?? "Registration cancelled",
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to cancel registration",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: "Unexpected error: $e");
    }
  }

  Future<ApiResponse<Event>> getEventById(String eventId) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.eventById(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {

        final data = response.data["data"];

        if (data is Map<String, dynamic>) {
          final event = Event.fromJson(data);

          return ApiResponse.success(
            data: event,
            statusCode: response.statusCode,
          );
        } else {
          return ApiResponse.error(
            message: "Invalid event format",
            statusCode: response.statusCode,
          );
        }
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to fetch event",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error: $e",
      );
    }
  }

  Future<ApiResponse<bool>> getMemberStatus({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.memberStatus(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        
        final data = response.data["data"];
        final status = data?["status"]?.toString();

        return ApiResponse.success(
          data: status == "joined",
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to get member status",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error: $e",
      );
    }
  }

  Future<ApiResponse<dynamic>> getEventResults({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.eventResults(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?['message'] ?? 'Failed to fetch event results',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }
}