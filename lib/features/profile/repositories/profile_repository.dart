import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/models/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  Future<ProfileModel?> fetchProfile() async {
    try {
      final meResponse = await _apiClient.get<dynamic>(ApiEndpoints.authMe);
      final statsResponse = await _apiClient.get<dynamic>(ApiEndpoints.authMeStats);

      final userMap = ResponseParser.extractMap(
        meResponse.data,
        const ['user', 'profile', 'data'],
      );
      final statsMap = ResponseParser.extractMap(
        statsResponse.data,
        const ['stats', 'data'],
      );

      if (userMap == null) return null;

      return ProfileModel.fromApi(
        user: userMap,
        stats: statsMap ?? const {},
      );
    } catch (_) {
      return null;
    }
  }

  Future<ProfilePerformanceInsights> fetchPerformanceInsights() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMePerformanceInsights,
      );

      final map = ResponseParser.extractMap(
        response.data,
        const ['insights', 'data'],
      );

      if (map == null) return ProfilePerformanceInsights.fallback;
      return ProfilePerformanceInsights.fromApi(map);
    } catch (_) {
      return ProfilePerformanceInsights.fallback;
    }
  }

  Future<List<ProfileEventHistoryItem>> fetchCompletedEvents() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeCompletedEvents,
        queryParameters: const {'page': 1, 'limit': 10},
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['events', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProfileEventHistoryItem.fromApi)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<ProfileUpcomingEventItem>> fetchActiveParticipations() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeActiveParticipations,
        queryParameters: const {'page': 1, 'limit': 10},
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['events', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProfileUpcomingEventItem.fromApi)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
