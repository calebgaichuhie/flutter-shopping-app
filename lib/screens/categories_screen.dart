// lib/screens/categories_screen.dart
// Categories screen

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../theme/app_colors.dart';
import 'product_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    _categories = Category.getAllCategories();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceSecondary,
          tabs: _categories.map((category) {
            return Tab(
              icon: Icon(category.icon),
              text: category.displayName,
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildCategoryTab(category);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryTab(Category category) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        // Filter products by category
        List<Product> categoryProducts;
        
        if (category.isAll) {
          categoryProducts = productProvider.allProducts;
        } else {
          categoryProducts = productProvider.allProducts
              .where((product) => product.category == category.name)
              .toList();
        }

        if (productProvider.isLoadingProducts) {
          return _buildLoadingGrid();
        }

        if (productProvider.hasError) {
          return _buildErrorWidget(productProvider.error!);
        }

        if (categoryProducts.isEmpty) {
          return _buildEmptyCategory(category);
        }

        return RefreshIndicator(
          onRefresh: () => productProvider.refresh(),
          child: CustomScrollView(
            slivers: [
              // Category header
              SliverToBoxAdapter(
                child: _buildCategoryHeader(category, categoryProducts.length),
              ),
              
              // Product grid
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => _navigateToProductDetail(product),
                      showAddToCart: true,
                    );
                  },
                ),
              ),
              
              // Final spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(Category category, int productCount) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: category.getGradient(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.getThemeColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category.getThemeColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              size: 32,
              color: category.getThemeColor(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  category.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: category.getThemeColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$productCount product${productCount != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: category.getThemeColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              height: 200 + (index % 2) * 50.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              'Error loading products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProductProvider>().refresh();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCategory(Category category) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: category.getThemeColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                size: 64,
                color: category.getThemeColor(),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No products in ${category.displayName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'This category will be available soon with amazing products',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Switch to first tab (All)
                _tabController.animateTo(0);
              },
              icon: Icon(Icons.explore),
              label: Text('Explore All Products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: category.getThemeColor(),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
