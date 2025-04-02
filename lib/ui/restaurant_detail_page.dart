import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/restaurant_model.dart';
import '../data/services/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/loading_progres.dart';
import '../providers/favorite_provider.dart';
import '../data/models/favorite_restuarant_model.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  RestaurantDetailPage({required this.restaurantId});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final RestaurantService _service = RestaurantService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  Restaurant? _restaurant;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama dan ulasan tidak boleh kosong')),
      );
      return;
    }

    try {
      await _service.postReview(widget.restaurantId, name, review);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ulasan berhasil dikirim')));
      _nameController.clear();
      _reviewController.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim ulasan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant Detail')),
      body: FutureBuilder<Restaurant>(
        future: _service.getRestaurantDetail(widget.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data tersedia'));
          } else {
            _restaurant = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://restaurant-api.dicoding.dev/images/medium/${_restaurant!.pictureId}',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _restaurant!.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          final isFavorite = favoriteProvider.isFavorite(
                            _restaurant!.id,
                          );
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                await favoriteProvider.removeFavorite(
                                  _restaurant!.id,
                                );
                              } else {
                                await favoriteProvider.addFavorite(
                                  FavoriteRestaurant(
                                    id: _restaurant!.id,
                                    name: _restaurant!.name,
                                    city: _restaurant!.city,
                                    rating: _restaurant!.rating,
                                    pictureId: _restaurant!.pictureId,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _restaurant!.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'City: ${_restaurant!.city}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Address: ${_restaurant!.address}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Rating: ${_restaurant!.rating}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Foods:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _restaurant!.foods
                        .map((food) => ListTile(title: Text(food.name)))
                        .toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Drinks:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _restaurant!.drinks
                        .map((drink) => ListTile(title: Text(drink.name)))
                        .toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Reviews:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _restaurant!.reviews
                        .map(
                          (review) => ListTile(
                            title: Text(review.name),
                            subtitle: Text(review.review),
                            trailing: Text(review.date),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Tambah Ulasan:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      labelText: 'Ulasan',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Kirim Ulasan'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
