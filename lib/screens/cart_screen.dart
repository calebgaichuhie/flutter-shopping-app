// lib/screens/cart_screen.dart
// Shopping cart screen

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../theme/app_colors.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isProcessingCheckout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.isEmpty) return SizedBox.shrink();
              
              return TextButton(
                onPressed: _showClearCartDialog,
                child: Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // Product list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return _buildCartItem(item, index);
                  },
                ),
              ),
              
              // Order summary
              _buildOrderSummary(cartProvider.summary),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: AppColors.onSurfaceSecondary,
            ),
            SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 12),
            Text(
              'Add some products to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              },
              icon: Icon(Icons.shopping_bag_outlined),
              label: Text('Explore Products'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Dismissible(
      key: Key('cart-item-${item.product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        final cartProvider = context.read<CartProvider>();
        cartProvider.removeItemAt(index);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.product.shortTitle} removed from cart'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                cartProvider.addToCart(item.product, quantity: item.quantity);
              },
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image
              GestureDetector(
                onTap: () => _navigateToProductDetail(item.product),
                child: Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.product.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              
              // Product information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _navigateToProductDetail(item.product),
                      child: Text(
                        item.product.shortTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    
                    // Category
                    Text(
                      item.product.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Price
                    Row(
                      children: [
                        if (item.hasDiscount) ...[
                          Text(
                            item.product.formattedPrice,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.onSurfaceSecondary,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            item.product.formattedDiscountedPrice,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else ...[
                          Text(
                            item.product.formattedPrice,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8),
                    
                    // Time added
                    Text(
                      'Added ${item.timeAgo}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Controles de cantidad
              Column(
                children: [
                  // Item total
                  Text(
                    item.formattedTotalDiscountedPrice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Quantity controls
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<CartProvider>().decrementQuantity(item.product);
                          },
                          icon: Icon(Icons.remove, size: 16),
                          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            item.quantity.toString(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<CartProvider>().incrementQuantity(item.product);
                          },
                          icon: Icon(Icons.add, size: 16),
                          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartSummary summary) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price summary
          _buildSummaryRow('Subtotal (${summary.totalItems} items)', summary.formattedSubtotal),
          
          if (summary.hasDiscounts) ...[
            _buildSummaryRow('Discounts', '-${summary.formattedDiscount}', isDiscount: true),
          ],
          
          _buildSummaryRow('Taxes', summary.formattedTax),
          _buildSummaryRow(
            'Shipping',
            summary.formattedShipping,
            isFree: summary.hasFreeShipping,
          ),
          
          Divider(thickness: 1, color: AppColors.divider),
          
          _buildSummaryRow(
            'Total',
            summary.formattedTotal,
            isTotal: true,
          ),
          
          // Free shipping message
          if (!summary.hasFreeShipping) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: AppColors.info, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add \$${(50 - summary.subtotal).toStringAsFixed(2)} more for free shipping',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: 16),
          
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessingCheckout ? null : _processCheckout,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessingCheckout
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Processing...'),
                      ],
                    )
                  : Text(
                      'Proceed to Payment (${summary.formattedTotal})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
    bool isFree = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? AppColors.onSurface : AppColors.onSurfaceSecondary,
            ),
          ),
          if (isFree) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'FREE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isDiscount
                    ? AppColors.success
                    : isTotal
                        ? AppColors.primary
                        : AppColors.onSurface,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToProductDetail(product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all products from the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processCheckout() async {
    setState(() {
      _isProcessingCheckout = true;
    });

    try {
      final cartProvider = context.read<CartProvider>();
      final success = await cartProvider.checkout();

      if (success) {
        _showCheckoutSuccessDialog();
      } else {
        _showCheckoutErrorDialog();
      }
    } catch (e) {
      _showCheckoutErrorDialog();
    } finally {
      setState(() {
        _isProcessingCheckout = false;
      });
    }
  }

  void _showCheckoutSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('Order Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order has been processed successfully.'),
            SizedBox(height: 8),
            Text(
              'You will receive an email confirmation with shipping details.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
            },
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: AppColors.error),
            SizedBox(width: 8),
            Text('Payment Error'),
          ],
        ),
        content: Text('There was a problem processing your order. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Understood'),
          ),
        ],
      ),
    );
  }
}
