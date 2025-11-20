// lib/models/cart_item.dart
// Data model for shopping cart items

import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.product,
    required this.quantity,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;

  @override
  String toString() {
    return 'CartItem(productId: ${product.id}, quantity: $quantity, total: $totalPrice)';
  }

  /// Calculates the total price for this item (price * quantity)
  double get totalPrice => product.price * quantity;

  /// Gets the total price formatted as string
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Calculates the total price with discount if applicable
  double get totalDiscountedPrice {
    if (product.hasDiscount) {
      return product.discountedPrice * quantity;
    }
    return totalPrice;
  }

  /// Gets the formatted total discounted price
  String get formattedTotalDiscountedPrice => '\$${totalDiscountedPrice.toStringAsFixed(2)}';

  /// Calculates the total savings if there is discount
  double get totalSavings => totalPrice - totalDiscountedPrice;

  /// Gets the formatted total savings
  String get formattedTotalSavings => '\$${totalSavings.toStringAsFixed(2)}';

  /// Checks if this item has discount
  bool get hasDiscount => product.hasDiscount;

  /// Gets the discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((totalPrice - totalDiscountedPrice) / totalPrice) * 100;
  }

  /// Increments the item quantity
  CartItem incrementQuantity() {
    return copyWith(quantity: quantity + 1);
  }

  /// Decrements the item quantity (minimum 1)
  CartItem decrementQuantity() {
    if (quantity <= 1) return this;
    return copyWith(quantity: quantity - 1);
  }

  /// Updates the item quantity
  CartItem updateQuantity(int newQuantity) {
    if (newQuantity < 1) return this;
    return copyWith(quantity: newQuantity);
  }

  /// Checks if the item is recent (added in the last 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(addedAt);
    return difference.inHours < 24;
  }

  /// Gets the time elapsed since added to cart
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }
}

/// Class to represent a cart summary
class CartSummary {
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;
  final double total;
  final int totalItems;

  CartSummary({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.totalItems,
  });

  factory CartSummary.fromItems(List<CartItem> items) {
    final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final discount = items.fold<double>(0.0, (sum, item) => sum + item.totalSavings);
    final tax = (subtotal - discount) * 0.08; // 8% tax
    final shipping = subtotal > 50 ? 0.0 : 9.99; // Free shipping for purchases > $50
    final total = subtotal - discount + tax + shipping;
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);

    return CartSummary(
      items: items,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      shipping: shipping,
      total: total,
      totalItems: totalItems,
    );
  }

  /// Gets the formatted subtotal
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';

  /// Gets the formatted discount
  String get formattedDiscount => '\$${discount.toStringAsFixed(2)}';

  /// Gets the formatted tax
  String get formattedTax => '\$${tax.toStringAsFixed(2)}';

  /// Gets the formatted shipping
  String get formattedShipping => shipping == 0 ? 'GRATIS' : '\$${shipping.toStringAsFixed(2)}';

  /// Gets the formatted total
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  /// Checks if there is free shipping
  bool get hasFreeShipping => shipping == 0;

  /// Checks if the cart is empty
  bool get isEmpty => items.isEmpty;

  /// Checks if there are discounts applied
  bool get hasDiscounts => discount > 0;
}
