import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';

class ChallengesRepository {
  final ApiClient _apiClient;

  ChallengesRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<ChallengeModel>> fetchChallenges() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.challenges,
        queryParameters: {
          'page': 1,
          'limit': 30,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['challenges', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(ChallengeModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<ChallengeModel?> fetchChallengeById(String id) async {
    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.challengeById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['challenge', 'item', 'data'],
      );

      if (map == null) return null;
      return ChallengeModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
