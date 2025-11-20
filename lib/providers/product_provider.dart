// lib/providers/product_provider.dart
// Provider to manage product state

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Product state
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _featuredProducts = [];
  List<Product> _newProducts = [];
  List<String> _categories = [];

  // Loading states
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  bool _isLoadingFeatured = false;
  bool _isLoadingNew = false;
  bool _isSearching = false;

  // Error state
  String? _error;

  // Filters and search
  String _selectedCategory = 'all';
  String _searchQuery = '';
  SortType _sortType = SortType.asc;
  ProductFilter _activeFilter = ProductFilter.all;

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get newProducts => _newProducts;
  List<String> get categories => _categories;

  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingFeatured => _isLoadingFeatured;
  bool get isLoadingNew => _isLoadingNew;
  bool get isSearching => _isSearching;

  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  SortType get sortType => _sortType;
  ProductFilter get activeFilter => _activeFilter;

  bool get hasError => _error != null;
  bool get hasProducts => _allProducts.isNotEmpty;
  bool get hasFilteredProducts => _filteredProducts.isNotEmpty;

  /// Initializes the provider loading initial data
  Future<void> initialize() async {
    await Future.wait([
      loadProducts(),
      loadCategories(),
      loadFeaturedProducts(),
      loadNewProducts(),
    ]);
  }

  /// Loads all products
  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.getAllProducts();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading products: $e');
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  /// Loads the categories
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Loads featured products
  Future<void> loadFeaturedProducts() async {
    _isLoadingFeatured = true;
    notifyListeners();

    try {
      _featuredProducts = await _apiService.getFeaturedProducts();
    } catch (e) {
      debugPrint('Error loading featured products: $e');
    } finally {
      _isLoadingFeatured = false;
      notifyListeners();
    }
  }

  /// Loads new products
  Future<void> loadNewProducts() async {
    _isLoadingNew = true;
    notifyListeners();

    try {
      _newProducts = await _apiService.getNewProducts();
    } catch (e) {
      debugPrint('Error loading new products: $e');
    } finally {
      _isLoadingNew = false;
      notifyListeners();
    }
  }

  /// Gets a product by ID
  Future<Product?> getProductById(int id) async {
    try {
      // First search in the loaded list
      final existingProduct = _allProducts.firstWhere(
        (product) => product.id == id,
        orElse: () => throw StateError('Product not found'),
      );
      return existingProduct;
    } catch (e) {
      // If not in the list, get it from API
      try {
        return await _apiService.getProduct(id);
      } catch (apiError) {
        debugPrint('Error getting product by ID: $apiError');
        return null;
      }
    }
  }

  /// Changes the selected category
  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Updates the search query
  Future<void> updateSearchQuery(String query) async {
    if (_searchQuery != query) {
      _searchQuery = query;
      
      if (query.isNotEmpty) {
        _isSearching = true;
        notifyListeners();
        
        try {
          _filteredProducts = await _apiService.searchProducts(query);
        } catch (e) {
          _error = e.toString();
          debugPrint('Error searching products: $e');
        } finally {
          _isSearching = false;
          notifyListeners();
        }
      } else {
        _applyFilters();
        notifyListeners();
      }
    }
  }

  /// Changes the sort type
  void changeSortType(SortType sortType) {
    if (_sortType != sortType) {
      _sortType = sortType;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Changes the active filter
  void changeFilter(ProductFilter filter) async {
    if (_activeFilter != filter) {
      _activeFilter = filter;
      
      switch (filter) {
        case ProductFilter.featured:
          if (_featuredProducts.isEmpty && !_isLoadingFeatured) {
            await loadFeaturedProducts();
          }
          _filteredProducts = _featuredProducts;
          break;
        case ProductFilter.new_arrivals:
          if (_newProducts.isEmpty && !_isLoadingNew) {
            await loadNewProducts();
          }
          _filteredProducts = _newProducts;
          break;
        case ProductFilter.high_rated:
          _filteredProducts = _allProducts
              .where((p) => p.rating != null && p.rating!.rate >= 4.0)
              .toList();
          break;
        case ProductFilter.price_low:
          _filteredProducts = List.from(_allProducts)
            ..sort((a, b) => a.price.compareTo(b.price));
          break;
        case ProductFilter.price_high:
          _filteredProducts = List.from(_allProducts)
            ..sort((a, b) => b.price.compareTo(a.price));
          break;
        default:
          _applyFilters();
          break;
      }
      
      notifyListeners();
    }
  }

  /// Gets related products
  Future<List<Product>> getRelatedProducts(Product product) async {
    try {
      return await _apiService.getRelatedProducts(product);
    } catch (e) {
      debugPrint('Error getting related products: $e');
      return [];
    }
  }

  /// Refreshes all data
  Future<void> refresh() async {
    _error = null;
    await initialize();
  }

  /// Applies filters based on category, search and sorting
  void _applyFilters() {
    List<Product> products = List.from(_allProducts);

    // Filter by category
    if (_selectedCategory != 'all') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }

    // Apply sorting
    switch (_sortType) {
      case SortType.asc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.desc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    _filteredProducts = products;
  }

  /// Clears the error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clears the search
  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  /// Gets product statistics
  Map<String, dynamic> getProductStats() {
    if (_allProducts.isEmpty) return {};

    final totalProducts = _allProducts.length;
    final averagePrice = _allProducts.fold<double>(0, (sum, p) => sum + p.price) / totalProducts;
    final categoryCounts = <String, int>{};
    
    for (final product in _allProducts) {
      categoryCounts[product.category] = (categoryCounts[product.category] ?? 0) + 1;
    }

    final highRatedCount = _allProducts
        .where((p) => p.rating != null && p.rating!.rate >= 4.0)
        .length;

    return {
      'totalProducts': totalProducts,
      'averagePrice': averagePrice,
      'categoryCounts': categoryCounts,
      'highRatedCount': highRatedCount,
      'highRatedPercentage': (highRatedCount / totalProducts) * 100,
    };
  }

  @override
  void dispose() {
    _apiService.cancelAllRequests();
    super.dispose();
  }
}
