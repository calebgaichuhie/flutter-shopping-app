// lib/models/category.dart
// Data model for Flutter Shopping app categories

import 'package:flutter/material.dart';

class Category {
  final String name;
  final String displayName;
  final IconData icon;
  final String description;

  const Category({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
  });

  /// Mapping of FakeStore API categories to our categories with icons
  static const Map<String, Category> categoryMap = {
    'electronics': Category(
      name: 'electronics',
      displayName: 'Electronics',
      icon: Icons.devices,
      description: 'Phones, laptops, tech accessories',
    ),
    'jewelery': Category(
      name: 'jewelery',
      displayName: 'Jewelry',
      icon: Icons.diamond,
      description: 'Jewels, watches, accessories',
    ),
    "men's clothing": Category(
      name: "men's clothing",
      displayName: 'Men\'s Clothing',
      icon: Icons.man,
      description: 'Clothing and accessories for men',
    ),
    "women's clothing": Category(
      name: "women's clothing",
      displayName: 'Women\'s Clothing',
      icon: Icons.woman,
      description: 'Clothing and accessories for women',
    ),
  };

  /// Special category for "All products"
  static const Category all = Category(
    name: 'all',
    displayName: 'All',
    icon: Icons.grid_view,
    description: 'All available products',
  );

  /// Gets a category by its name
  static Category? fromName(String name) {
    if (name == 'all') return all;
    return categoryMap[name];
  }

  /// Gets all available categories including "All"
  static List<Category> getAllCategories() {
    return [all, ...categoryMap.values];
  }

  /// Gets only API categories (without "All")
  static List<Category> getApiCategories() {
    return categoryMap.values.toList();
  }

  /// Gets the names of API categories
  static List<String> getApiCategoryNames() {
    return categoryMap.keys.toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Category(name: $name, displayName: $displayName)';
  }

  /// Checks if this is the "All" category
  bool get isAll => name == 'all';

  /// Gets the theme color for the category
  Color getThemeColor() {
    switch (name) {
      case 'electronics':
        return Colors.blue;
      case 'jewelery':
        return Colors.purple;
      case "men's clothing":
        return Colors.green;
      case "women's clothing":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  /// Gets a color gradient for the category
  LinearGradient getGradient() {
    final color = getThemeColor();
    return LinearGradient(
      colors: [color.withOpacity(0.1), color.withOpacity(0.3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
