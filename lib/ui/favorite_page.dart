import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import 'restaurant_detail_page.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorit Restoran')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return Center(child: Text('Tidak ada restoran favorit'));
          }
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final restaurant = provider.favorites[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(
                    '${restaurant.city} - Rating: ${restaurant.rating}',
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      provider.isFavorite(restaurant.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          provider.isFavorite(restaurant.id)
                              ? Colors.red
                              : Colors.grey,
                    ),
                    onPressed: () {
                      if (provider.isFavorite(restaurant.id)) {
                        provider.removeFavorite(restaurant.id);
                      } else {
                        provider.addFavorite(restaurant);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RestaurantDetailPage(
                              restaurantId: restaurant.id,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
