import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/feed_posts/models/feed_post_model.dart';

class FeedPostsRepository {
  final ApiClient _apiClient;

  FeedPostsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<FeedPostModel>> fetchPosts({Map<String, dynamic>? queryParameters}) async {
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
      final response = await _apiClient.get<dynamic>(ApiEndpoints.feedPostById(id));

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

  Future<bool> createPost(Map<String, dynamic> payload) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.feedPosts,
        data: payload,
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
