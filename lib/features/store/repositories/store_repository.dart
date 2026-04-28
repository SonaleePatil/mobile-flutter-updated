import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/store/models/store_item_model.dart';

class StoreRepository {
  final ApiClient _apiClient;

  StoreRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<StoreItemModel>> fetchItems() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.storeItems,
        queryParameters: {
          'page': 1,
          'limit': 50,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['items', 'products', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(StoreItemModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<StoreItemModel?> fetchItemById(String id) async {
    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.storeItemById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['item', 'product', 'data'],
      );

      if (map == null) return null;
      return StoreItemModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
