import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';

class RestaurantService {
  final String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var restaurants = jsonResponse['restaurants'] as List;
      return restaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var restaurants = jsonResponse['restaurants'] as List;
      return restaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<Restaurant> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Restaurant.fromJson(jsonResponse['restaurant']);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<void> postReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post review');
    }
  }
}
