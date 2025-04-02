import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/restaurant_model.dart';
import '../providers/restaurant_provider.dart';
import '../data/enum/result_state.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/loading_progres.dart';
import 'restaurant_detail_page.dart';
import 'search_page.dart';
import 'setting_page.dart';
import 'favorite_page.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RestaurantListContent(),
    FavoritePage(),
    SettingsPage(),
  ];

  // Fungsi untuk mengubah halaman saat tombol ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text('Cari Resto'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ],
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RestaurantListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, child) {
        final state = provider.state;
        if (state is RestaurantLoading) {
          return LoadingWidget();
        } else if (state is RestaurantError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is RestaurantNoData) {
          return Center(child: Text(state.message));
        } else if (state is RestaurantLoaded) {
          return ListView.builder(
            itemCount: state.restaurants.length,
            itemBuilder: (context, index) {
              Restaurant restaurant = state.restaurants[index];
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailPage(
                          restaurantId: restaurant.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
