// lib/providers/cart_provider.dart
// Provider to manage shopping cart state

import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  
  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  /// Gets the cart summary
  CartSummary get summary => CartSummary.fromItems(_items);

  /// Checks if a product is in the cart
  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  /// Gets the quantity of a product in the cart
  int getQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }

  /// Gets a cart item by product ID
  CartItem? getCartItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Adds a product to the cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // If the product is already in the cart, update quantity
      final existingItem = _items[existingItemIndex];
      _items[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // If it's a new product, add it to the cart
      _items.add(CartItem(
        product: product,
        quantity: quantity,
      ));
    }

    notifyListeners();
    debugPrint('Product added to cart: ${product.title} (Quantity: $quantity)');
  }

  /// Removes a product from the cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
    debugPrint('Product removed from cart: ${product.title}');
  }

  /// Removes a cart item by index
  void removeItemAt(int index) {
    if (index >= 0 && index < _items.length) {
      final removedItem = _items.removeAt(index);
      notifyListeners();
      debugPrint('Item removed from cart: ${removedItem.product.title}');
    }
  }

  /// Updates the quantity of a product in the cart
  void updateQuantity(Product product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
      return;
    }

    final itemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (itemIndex >= 0) {
      _items[itemIndex] = _items[itemIndex].copyWith(quantity: newQuantity);
      notifyListeners();
      debugPrint('Quantity updated for ${product.title}: $newQuantity');
    }
  }

  /// Increments the quantity of a product
  void incrementQuantity(Product product) {
    final currentQuantity = getQuantity(product);
    if (currentQuantity > 0) {
      updateQuantity(product, currentQuantity + 1);
    } else {
      addToCart(product);
    }
  }

  /// Decrements the quantity of a product
  void decrementQuantity(Product product) {
    final currentQuantity = getQuantity(product);
    if (currentQuantity > 1) {
      updateQuantity(product, currentQuantity - 1);
    } else if (currentQuantity == 1) {
      removeFromCart(product);
    }
  }

  /// Clears the entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
    debugPrint('Cart cleared');
  }

  /// Gets items by category
  Map<String, List<CartItem>> getItemsByCategory() {
    final Map<String, List<CartItem>> categoryMap = {};
    
    for (final item in _items) {
      final category = item.product.category;
      if (!categoryMap.containsKey(category)) {
        categoryMap[category] = [];
      }
      categoryMap[category]!.add(item);
    }
    
    return categoryMap;
  }

  /// Gets the most expensive products in the cart
  List<CartItem> getMostExpensiveItems({int limit = 3}) {
    final sortedItems = List<CartItem>.from(_items)
      ..sort((a, b) => b.product.price.compareTo(a.product.price));
    
    return sortedItems.take(limit).toList();
  }

  /// Gets recently added items
  List<CartItem> getRecentItems({int limit = 3}) {
    final sortedItems = List<CartItem>.from(_items)
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    
    return sortedItems.take(limit).toList();
  }

  /// Gets discounted items
  List<CartItem> getDiscountedItems() {
    return _items.where((item) => item.hasDiscount).toList();
  }

  /// Checks if qualifies for free shipping
  bool qualifiesForFreeShipping({double threshold = 50.0}) {
    return summary.subtotal >= threshold;
  }

  /// Calculates how much is left for free shipping
  double amountForFreeShipping({double threshold = 50.0}) {
    final current = summary.subtotal;
    return current >= threshold ? 0.0 : threshold - current;
  }

  /// Gets cart statistics
  Map<String, dynamic> getCartStats() {
    if (_items.isEmpty) {
      return {
        'isEmpty': true,
        'totalItems': 0,
        'totalQuantity': 0,
        'totalValue': 0.0,
        'averageItemPrice': 0.0,
        'categoriesCount': 0,
      };
    }

    final categoriesCount = getItemsByCategory().keys.length;
    final totalValue = summary.subtotal;
    final averageItemPrice = totalValue / totalQuantity;

    return {
      'isEmpty': false,
      'totalItems': itemCount,
      'totalQuantity': totalQuantity,
      'totalValue': totalValue,
      'averageItemPrice': averageItemPrice,
      'categoriesCount': categoriesCount,
      'hasDiscounts': summary.hasDiscounts,
      'totalSavings': summary.discount,
      'qualifiesForFreeShipping': qualifiesForFreeShipping(),
    };
  }

  /// Simulates the checkout process
  Future<bool> checkout() async {
    if (_items.isEmpty) return false;

    try {
      // Simulate payment process
      await Future.delayed(Duration(seconds: 2));
      
      // Clear cart after successful checkout
      clearCart();
      
      debugPrint('Checkout completed successfully');
      return true;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }

  /// Saves the cart to local storage (simulated)
  Future<void> saveCart() async {
    // In a real implementation, you would save to SharedPreferences or SQLite
    debugPrint('Carrito guardado (simulado)');
  }

  /// Loads the cart from local storage (simulated)
  Future<void> loadCart() async {
    // In a real implementation, you would load from SharedPreferences or SQLite
    debugPrint('Carrito cargado (simulado)');
  }

  /// Gets recommendations based on current cart
  List<String> getRecommendedCategories() {
    if (_items.isEmpty) return [];

    final categoryFrequency = <String, int>{};
    for (final item in _items) {
      final category = item.product.category;
      categoryFrequency[category] = (categoryFrequency[category] ?? 0) + 1;
    }

    // Sort by frequency and return the most frequent categories
    final sortedCategories = categoryFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.map((e) => e.key).toList();
  }

  /// Duplicates an item in the cart
  void duplicateItem(CartItem item) {
    addToCart(item.product, quantity: item.quantity);
  }

  /// Moves an item to wishlist (simulated)
  void moveToWishlist(CartItem item) {
    removeFromCart(item.product);
    debugPrint('Item moved to wishlist: ${item.product.title}');
  }

  @override
  String toString() {
    return 'CartProvider(items: ${_items.length}, total: ${summary.formattedTotal})';
  }
}
