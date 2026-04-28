import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/home/models/home_models.dart';

class HomeRepository {
  final ApiClient _apiClient;

  HomeRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<HomeFeedModel> fetchHomeFeed() async {
    final events = await _fetchEvents();
    final communities = await _fetchCommunities();

    return HomeFeedModel(
      featuredEvent: events.isEmpty ? null : events.first,
      upcomingEvents: events,
      popularCommunities: communities,
    );
  }

  Future<List<HomeEventModel>> _fetchEvents() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.events,
        queryParameters: {
          'status': 'Open',
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['events', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeEventModel.fromJson)
          .toList();
    } catch (e) {
      print("❌ Events API Error: $e");
      rethrow; // 🔥 important;
    }
  }

  Future<List<HomeCommunityModel>> _fetchCommunities() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.communities,
        queryParameters: {
          'isFeatured': true,
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['communities', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeCommunityModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
