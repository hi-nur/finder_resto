import '../models/restaurant_model.dart';

sealed class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  RestaurantLoaded(this.restaurants);
}

class RestaurantNoData extends RestaurantState {
  final String message;
  RestaurantNoData(this.message);
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}