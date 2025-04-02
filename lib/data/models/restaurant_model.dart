class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final double rating;
  final String pictureId;
  final List<Food> foods;
  final List<Drink> drinks;
  final List<Review> reviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.rating,
    required this.pictureId,
    required this.foods,
    required this.drinks,
    required this.reviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      pictureId: json['pictureId'] ?? '',
      foods: List<Food>.from(
        (json['menus']?['foods'] as List? ?? [])
            .map((food) => Food.fromJson(food))
            .toList(),
      ),
      drinks: List<Drink>.from(
        (json['menus']?['drinks'] as List? ?? [])
            .map((drink) => Drink.fromJson(drink))
            .toList(),
      ),
      reviews: List<Review>.from(
        (json['customerReviews'] as List? ?? [])
            .map((review) => Review.fromJson(review))
            .toList(),
      ),
    );
  }
}

class Food {
  final String name;

  Food({required this.name});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(name: json['name'] ?? '');
  }
}

class Drink {
  final String name;

  Drink({required this.name});

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(name: json['name'] ?? '');
  }
}

class Review {
  final String name;
  final String review;
  final String date;

  Review({required this.name, required this.review, required this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
