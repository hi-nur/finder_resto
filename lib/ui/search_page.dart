import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../data/models/restaurant_model.dart';
import '../data/enum/result_state.dart';
import '../widgets/loading_progres.dart';
import 'restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Cari restoran...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      Provider.of<RestaurantProvider>(
                        context,
                        listen: false,
                      ).searchRestaurants(query);
                    }
                  },
                )
                : Text('Cari Restoran'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (_isSearching) {
                _clearSearch();
              } else {
                _startSearch();
              }
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          final state = provider.state;
          if (state is RestaurantLoading) {
            return LoadingWidget();
          } else if (state is RestaurantError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is RestaurantNoData) {
            return Center(child: Text(state.message));
          } else if (state is RestaurantLoaded) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom dalam grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8, // Rasio lebar-tinggi item
              ),
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = state.restaurants[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            restaurant.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${restaurant.city} - Rating: ${restaurant.rating}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text('Masukkan kata kunci untuk mencari restoran'),
          );
        },
      ),
    );
  }
}
