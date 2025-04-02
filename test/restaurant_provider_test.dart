import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto/data/services/service_api.dart';
import 'package:resto/data/models/restaurant_model.dart';
import 'package:resto/providers/restaurant_provider.dart';
import 'package:resto/data/enum/result_state.dart';
import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([RestaurantService])
void main() {
  late RestaurantProvider restaurantProvider;
  late MockRestaurantService
      mockRestaurantService; // Using MockRestaurantService

  setUp(() {
    mockRestaurantService =
        MockRestaurantService(); // Using MockRestaurantService
    restaurantProvider = RestaurantProvider(service: mockRestaurantService);
  });

  group('RestaurantProvider Tests', () {
    test('Initial state should be RestaurantInitial', () {
      expect(restaurantProvider.state, isA<RestaurantInitial>());
    });

    test('Should return list of restaurants when API call is successful',
        () async {
      final mockRestaurants = [
        Restaurant(
          id: '1',
          name: 'Resto 1',
          description: 'Description 1',
          city: 'City 1',
          address: 'Address 1',
          rating: 4.5,
          pictureId: 'picture1',
          foods: [],
          drinks: [],
          reviews: [],
        ),
        Restaurant(
          id: '2',
          name: 'Resto 2',
          description: 'Description 2',
          city: 'City 2',
          address: 'Address 2',
          rating: 4.0,
          pictureId: 'picture2',
          foods: [],
          drinks: [],
          reviews: [],
        ),
      ];

      // Using MockRestaurantService
      when(mockRestaurantService.getRestaurants()).thenAnswer(
        (_) async => Future.value(mockRestaurants),
      );

      await restaurantProvider.fetchRestaurants();

      expect(restaurantProvider.state, isA<RestaurantLoaded>());
      if (restaurantProvider.state is RestaurantLoaded) {
        final loadedState = restaurantProvider.state as RestaurantLoaded;
        expect(loadedState.restaurants, mockRestaurants);
      }

      verify(mockRestaurantService.getRestaurants()).called(1);
    });

    test('Should return error when API call fails', () async {
      // Using MockRestaurantService
      when(mockRestaurantService.getRestaurants()).thenAnswer(
        (_) => Future.error(Exception('Failed to load restaurants')),
      );

      await restaurantProvider.fetchRestaurants();

      expect(restaurantProvider.state, isA<RestaurantError>());
      if (restaurantProvider.state is RestaurantError) {
        final errorState = restaurantProvider.state as RestaurantError;
        expect(errorState.message, contains('Failed to load restaurants'));
      }

      verify(mockRestaurantService.getRestaurants()).called(1);
    });
  });
}
