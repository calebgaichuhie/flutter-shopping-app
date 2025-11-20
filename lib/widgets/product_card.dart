// lib/widgets/product_card.dart
// Widget to display products in card form

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showAddToCart;
  final double? width;
  final double? height;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showAddToCart = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductTitle(context),
                      SizedBox(height: 4),
                      _buildProductCategory(context),
                      SizedBox(height: 8),
                      _buildProductRating(context),
                      Spacer(),
                      _buildProductPrice(context),
                      if (showAddToCart) ...[
                        SizedBox(height: 8),
                        _buildAddToCartSection(context),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: product.image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceVariant,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceVariant,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 40,
                    color: AppColors.onSurfaceSecondary,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Error loading',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Discount badge
          if (product.hasDiscount) ...[
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-10%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          
          // Favorite button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: AppColors.onSurface,
                ),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => _addToWishlist(),
                padding: EdgeInsets.all(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitle(BuildContext context) {
    return Text(
      product.shortTitle,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProductCategory(BuildContext context) {
    return Text(
      product.category.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildProductRating(BuildContext context) {
    if (product.rating == null) return SizedBox.shrink();
    
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 14,
          color: AppColors.warning,
        ),
        SizedBox(width: 2),
        Text(
          product.rating!.formattedRate,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '(${product.rating!.count})',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductPrice(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.hasDiscount) ...[
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          Text(
            product.formattedDiscountedPrice,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else ...[
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddToCartSection(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(product);
        final quantity = cartProvider.getQuantity(product);

        if (isInCart) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => cartProvider.decrementQuantity(product),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Icon(Icons.remove, size: 16),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            quantity.toString(),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => cartProvider.incrementQuantity(product),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return SizedBox(
          width: double.infinity,
          height: 32,
          child: ElevatedButton.icon(
            onPressed: () {
              cartProvider.addToCart(product);
              _showAddedToCartSnackbar(context);
            },
            icon: Icon(
              Icons.add_shopping_cart,
              size: 16,
            ),
            label: Text(
              'Add',
              style: TextStyle(fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              minimumSize: Size.zero,
            ),
          ),
        );
      },
    );
  }

  void _addToWishlist() {
    // Implement wishlist functionality
    print('Added to wishlist: ${product.title}');
  }

  void _showAddedToCartSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.shortTitle} added to cart',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
