import 'package:flutter/material.dart';
import '../data/services/service_api.dart';
import '../data/models/restaurant_model.dart';
import '../data/enum/result_state.dart';

class RestaurantProvider with ChangeNotifier {
  RestaurantState _state = RestaurantInitial();
  RestaurantState get state => _state;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  final RestaurantService _service;

  // Constructor yang menerima RestaurantService
  RestaurantProvider({required RestaurantService service}) : _service = service;

  Future<void> fetchRestaurants() async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final restaurants = await _service.getRestaurants();
      if (restaurants.isEmpty) {
        _state = RestaurantNoData("Tidak ada data ditemukan");
      } else {
        _state = RestaurantLoaded(restaurants);
        _restaurants = restaurants;
      }
    } catch (e) {
      _state = RestaurantError(e.toString());
    }

    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final restaurants = await _service.searchRestaurants(query);
      if (restaurants.isEmpty) {
        _state = RestaurantNoData(
          "Tidak ada restoran ditemukan dengan kata kunci '$query'",
        );
      } else {
        _state = RestaurantLoaded(restaurants);
        _restaurants = restaurants;
      }
    } catch (e) {
      _state = RestaurantError(e.toString());
    }

    notifyListeners();
  }
}
