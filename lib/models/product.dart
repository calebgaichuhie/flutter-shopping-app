// lib/models/product.dart
// Data model for FakeStore API products

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toJson(),
    };
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, category: $category)';
  }

  /// Gets the formatted price as text
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Gets the first line of the title to display in cards
  String get shortTitle {
    if (title.length <= 50) return title;
    return '${title.substring(0, 47)}...';
  }

  /// Gets a short description for cards
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 97)}...';
  }

  /// Checks if the product has discount based on high rating
  bool get hasDiscount => rating != null && rating!.rate >= 4.0;

  /// Calculates a fictitious discounted price for high rating products
  double get discountedPrice {
    if (!hasDiscount) return price;
    return price * 0.9; // 10% de descuento
  }

  /// Gets the formatted discounted price
  String get formattedDiscountedPrice => '\$${discountedPrice.toStringAsFixed(2)}';
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }

  /// Gets the rating as formatted string
  String get formattedRate => rate.toStringAsFixed(1);

  /// Gets the stars as visual string
  String get starsDisplay {
    final fullStars = rate.floor();
    final hasHalfStar = (rate - fullStars) >= 0.5;
    
    String stars = '★' * fullStars;
    if (hasHalfStar) stars += '☆';
    
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    stars += '☆' * emptyStars;
    
    return stars;
  }

  /// Converts the rating to a percentage of 5 stars
  double get percentage => (rate / 5.0) * 100;

  @override
  String toString() {
    return 'Rating(rate: $rate, count: $count)';
  }
}
