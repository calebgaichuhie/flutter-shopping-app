// lib/services/api_service.dart
// Service to connect with FakeStore API

import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for logging in development
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print('[API] $object'),
    ));
  }

  /// Gets all products
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> productsJson = response.data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Error getting products: ${e.toString()}');
    }
  }

  /// Gets a specific product by ID
  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw ApiException('Error getting product $id: ${e.toString()}');
    }
  }

  /// Gets all available categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return List<String>.from(response.data);
    } catch (e) {
      throw ApiException('Error getting categories: ${e.toString()}');
    }
  }

  /// Gets products from a specific category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      final List<dynamic> productsJson = response.data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Error getting products from category $category: ${e.toString()}');
    }
  }

  /// Gets products with limit (for pagination)
  Future<List<Product>> getLimitedProducts(int limit) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        'limit': limit,
      });
      final List<dynamic> productsJson = response.data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Error getting limited products: ${e.toString()}');
    }
  }

  /// Gets sorted products (asc or desc)
  Future<List<Product>> getSortedProducts(String sort) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        'sort': sort,
      });
      final List<dynamic> productsJson = response.data;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Error getting sorted products: ${e.toString()}');
    }
  }

  /// Searches products by title (local implementation since API doesn't have search)
  Future<List<Product>> searchProducts(String query) async {
    try {
      final allProducts = await getAllProducts();
      if (query.isEmpty) return allProducts;
      
      final searchQuery = query.toLowerCase();
      return allProducts.where((product) {
        return product.title.toLowerCase().contains(searchQuery) ||
               product.description.toLowerCase().contains(searchQuery) ||
               product.category.toLowerCase().contains(searchQuery);
      }).toList();
    } catch (e) {
      throw ApiException('Error searching products: ${e.toString()}');
    }
  }

  /// Gets products filtered by price range
  Future<List<Product>> getProductsByPriceRange(double minPrice, double maxPrice) async {
    try {
      final allProducts = await getAllProducts();
      return allProducts.where((product) {
        return product.price >= minPrice && product.price <= maxPrice;
      }).toList();
    } catch (e) {
      throw ApiException('Error filtering products by price: ${e.toString()}');
    }
  }

  /// Gets products with minimum rating
  Future<List<Product>> getProductsByRating(double minRating) async {
    try {
      final allProducts = await getAllProducts();
      return allProducts.where((product) {
        return product.rating != null && product.rating!.rate >= minRating;
      }).toList();
    } catch (e) {
      throw ApiException('Error filtering products by rating: ${e.toString()}');
    }
  }

  /// Gets featured products (high rating and many reviews)
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final allProducts = await getAllProducts();
      final featured = allProducts.where((product) {
        return product.rating != null && 
               product.rating!.rate >= 4.0 && 
               product.rating!.count >= 100;
      }).toList();
      
      // Sort by rating descending
      featured.sort((a, b) => b.rating!.rate.compareTo(a.rating!.rate));
      
      return featured.take(6).toList(); // Maximum 6 featured products
    } catch (e) {
      throw ApiException('Error getting featured products: ${e.toString()}');
    }
  }

  /// Gets new products (simulated - latest IDs)
  Future<List<Product>> getNewProducts() async {
    try {
      final allProducts = await getAllProducts();
      // Simular productos nuevos tomando los últimos IDs
      allProducts.sort((a, b) => b.id.compareTo(a.id));
      return allProducts.take(8).toList();
    } catch (e) {
      throw ApiException('Error getting new products: ${e.toString()}');
    }
  }

  /// Gets related products (same category, excluding current)
  Future<List<Product>> getRelatedProducts(Product product) async {
    try {
      final categoryProducts = await getProductsByCategory(product.category);
      return categoryProducts
          .where((p) => p.id != product.id)
          .take(4)
          .toList();
    } catch (e) {
      throw ApiException('Error getting related products: ${e.toString()}');
    }
  }

  /// Checks API connectivity
  Future<bool> checkApiHealth() async {
    try {
      final response = await _dio.get('/products?limit=1');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Cancels all pending requests
  void cancelAllRequests() {
    _dio.clear();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

/// Enumeration for sort types
enum SortType {
  asc('asc', 'Price: Low to High'),
  desc('desc', 'Price: High to Low');

  const SortType(this.value, this.displayName);
  
  final String value;
  final String displayName;
}

/// Enumeration for product filters
enum ProductFilter {
  all('All'),
  featured('Featured'),
  new_arrivals('New'),
  high_rated('Top Rated'),
  price_low('Low Price'),
  price_high('High Price');

  const ProductFilter(this.displayName);
  
  final String displayName;
}
