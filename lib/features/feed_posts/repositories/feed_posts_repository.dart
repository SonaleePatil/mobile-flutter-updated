import 'dart:io';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/feed_posts/models/feed_post_model.dart';
import 'package:dio/dio.dart';

class FeedPostsRepository {
  final ApiClient _apiClient;

  FeedPostsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<FeedPostModel>> fetchPosts(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.feedPosts,
        queryParameters: queryParameters,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['posts', 'items', 'results', 'data'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(FeedPostModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<FeedPostModel?> fetchPostById(String id) async {
    try {
      final response =
          await _apiClient.get<dynamic>(ApiEndpoints.feedPostById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      return FeedPostModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<List<FeedPostModel>> fetchMyPosts() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.feedMyPosts,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['posts', 'items', 'results', 'data'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(FeedPostModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> createPost({
    required String description,
    String? title,
    File? image,
  }) async {
    try {
      final payload = <String, dynamic>{
        'title':
            (title?.trim().isNotEmpty ?? false) ? title!.trim() : 'Ride update',
        'description': description.trim(),
        'status': 'pending_approval',
      };

      dynamic data = payload;
      Options? options;

      if (image != null) {
        data = FormData.fromMap({
          ...payload,
          'image': await MultipartFile.fromFile(image.path),
        });
        options = Options(contentType: 'multipart/form-data');
      }

      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.feedPosts,
        data: data,
        options: options,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<FeedPostModel?> toggleLike(String id) async {
    try {
      final response =
          await _apiClient.post<dynamic>(ApiEndpoints.feedLike(id));
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      return FeedPostModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<FeedPostModel?> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.feedComments(postId),
        data: {'text': text.trim()},
      );
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      return FeedPostModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<FeedPostModel?> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.feedCommentById(postId, commentId),
      );
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      return FeedPostModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
