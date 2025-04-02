class FavoriteRestaurant {
  final String id;
  final String name;
  final String city;
  final double rating;
  final String pictureId;

  FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.pictureId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'rating': rating,
      'pictureId': pictureId,
    };
  }

  factory FavoriteRestaurant.fromMap(Map<String, dynamic> map) {
    return FavoriteRestaurant(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      rating: map['rating'],
      pictureId: map['pictureId'],
    );
  }
}
