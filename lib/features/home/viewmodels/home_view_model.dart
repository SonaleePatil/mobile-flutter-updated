import 'package:flutter/foundation.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/home/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;

  HomeViewModel({HomeRepository? repository})
      : _repository = repository ?? HomeRepository();

  bool isLoading = false;
  String? error;
  HomeFeedModel? feed;

  Future<void> loadHome() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      feed = await _repository.fetchHomeFeed();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
