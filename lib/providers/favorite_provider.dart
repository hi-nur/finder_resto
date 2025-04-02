import 'package:flutter/material.dart';
import '../data/helpers/database_helper.dart';
import '../data/models/favorite_restuarant_model.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<FavoriteRestaurant> _favorites = [];

  List<FavoriteRestaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteRestaurant restaurant) async {
    await _databaseHelper.insertFavorite(restaurant);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _databaseHelper.deleteFavorite(id);
    await loadFavorites();
  }

  // Tambahkan method isFavorite
  bool isFavorite(String id) {
    return _favorites.any((fav) => fav.id == id);
  }
}
