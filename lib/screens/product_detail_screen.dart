// lib/screens/product_detail_screen.dart
// Product detail screen

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../theme/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _relatedProducts = [];
  bool _isLoadingRelated = false;
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _loadRelatedProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRelatedProducts() async {
    setState(() {
      _isLoadingRelated = true;
    });

    try {
      final productProvider = context.read<ProductProvider>();
      final relatedProducts = await productProvider.getRelatedProducts(widget.product);
      setState(() {
        _relatedProducts = relatedProducts;
      });
    } catch (e) {
      debugPrint('Error loading related products: $e');
    } finally {
      setState(() {
        _isLoadingRelated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProduct,
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: _addToWishlist,
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Product image
          SliverToBoxAdapter(
            child: _buildProductImage(),
          ),
          
          // Product information
          SliverToBoxAdapter(
            child: _buildProductInfo(),
          ),
          
          // Description
          SliverToBoxAdapter(
            child: _buildProductDescription(),
          ),
          
          // Rating and reviews
          SliverToBoxAdapter(
            child: _buildRatingSection(),
          ),
          
          // Quantity selector
          SliverToBoxAdapter(
            child: _buildQuantitySelector(),
          ),
          
          // Related products
          SliverToBoxAdapter(
            child: _buildRelatedProducts(),
          ),
          
          // Spacing for fixed button
          SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 400,
      child: Hero(
        tag: 'product-${widget.product.id}',
        child: CachedNetworkImage(
          imageUrl: widget.product.image,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            color: AppColors.surface,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 64,
                  color: AppColors.onSurfaceSecondary,
                ),
                SizedBox(height: 8),
                Text(
                  'Error loading image',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.product.category.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          SizedBox(height: 12),
          
          // Title
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          
          // Price
          Row(
            children: [
              if (widget.product.hasDiscount) ...[
                Text(
                  widget.product.formattedPrice,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  widget.product.formattedDiscountedPrice,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-10%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  widget.product.formattedPrice,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 12),
          Text(
            widget.product.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    if (widget.product.rating == null) return SizedBox.shrink();

    final rating = widget.product.rating!;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ratings and Reviews',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Rating numérico
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      rating.formattedRate,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'out of 5.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              
              // Estrellas y conteo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.rate.floor()
                              ? Icons.star
                              : index < rating.rate
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: AppColors.warning,
                          size: 20,
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${rating.count} reviews',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _selectedQuantity > 1
                    ? () => setState(() => _selectedQuantity--)
                    : null,
                icon: Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceVariant,
                  foregroundColor: AppColors.onSurface,
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedQuantity.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: _selectedQuantity < 99
                    ? () => setState(() => _selectedQuantity++)
                    : null,
                icon: Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
              ),
              Spacer(),
              Text(
                'Total: ${(widget.product.price * _selectedQuantity).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts() {
    if (_isLoadingRelated || _relatedProducts.isEmpty) {
      return _isLoadingRelated ? _buildRelatedProductsLoading() : SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Related Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: _relatedProducts.length,
              itemBuilder: (context, index) {
                final product = _relatedProducts[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(product),
                    showAddToCart: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductsLoading() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Related Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Card(
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(widget.product);
        final cartQuantity = cartProvider.getQuantity(widget.product);

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
          child: Row(
            children: [
              if (isInCart) ...[
                // Quantity controls if in cart
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          cartProvider.decrementQuantity(widget.product);
                        },
                        icon: Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'In cart: $cartQuantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          cartProvider.incrementQuantity(widget.product);
                        },
                        icon: Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Button to add to cart
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(widget.product, quantity: _selectedQuantity);
                      _showAddedToCartSnackBar();
                    },
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
              SizedBox(width: 12),
              
              // Buy now button
              ElevatedButton(
                onPressed: () {
                  _buyNow();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onSecondary,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: Text('Buy'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _shareProduct() {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing feature coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _addToWishlist() {
    // Implement wishlist functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to wishlist'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showAddedToCartSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text('${widget.product.shortTitle} added to cart'),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pushNamed('/cart');
          },
        ),
      ),
    );
  }

  void _buyNow() {
    final cartProvider = context.read<CartProvider>();
    
    // Add to cart if not already
    if (!cartProvider.isInCart(widget.product)) {
      cartProvider.addToCart(widget.product, quantity: _selectedQuantity);
    }
    
    // Navigate to cart
    Navigator.of(context).pushNamed('/cart');
  }
}
