// lib/screens/home_screen.dart
// Main screen of the Flutter Shopping App

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/app_colors.dart';
import 'product_detail_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Flutter Shopping',
        searchController: _searchController,
        onSearchChanged: (query) {
          context.read<ProductProvider>().updateSearchQuery(query);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductProvider>().refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Categories section
            SliverToBoxAdapter(
              child: _buildCategoriesSection(),
            ),
            
            // Filters section
            SliverToBoxAdapter(
              child: _buildFiltersSection(),
            ),
            
            // Featured products section
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoadingFeatured) {
                  return SliverToBoxAdapter(
                    child: _buildFeaturedLoadingSection(),
                  );
                }
                
                if (productProvider.featuredProducts.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: _buildFeaturedSection(productProvider.featuredProducts),
                  );
                }
                
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            
            // Main products section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'All Products',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoadingProducts) {
                  return _buildProductsLoadingSliver();
                }
                
                if (productProvider.hasError) {
                  return _buildErrorSliver(productProvider.error!);
                }
                
                if (!productProvider.hasFilteredProducts) {
                  return _buildEmptySliver();
                }
                
                return _buildProductsSliver(productProvider.filteredProducts);
              },
            ),
            
            // Final spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 120,
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoadingCategories) {
            return Center(child: CircularProgressIndicator());
          }
          
          final categories = Category.getAllCategories();
          
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = productProvider.selectedCategory == category.name;
              
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: CategoryChip(
                  category: category,
                  isSelected: isSelected,
                  onTap: () {
                    productProvider.selectCategory(category.name);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: ProductFilter.values.length,
            itemBuilder: (context, index) {
              final filter = ProductFilter.values[index];
              final isSelected = productProvider.activeFilter == filter;
              
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      productProvider.changeFilter(filter);
                    }
                  },
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(List<Product> featuredProducts) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Products',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    context.read<ProductProvider>().changeFilter(ProductFilter.featured);
                  },
                  child: Text('See all'),
                ),
              ],
            ),
          ),
          Container(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: featuredProducts.length,
              itemBuilder: (context, index) {
                final product = featuredProducts[index];
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

  Widget _buildFeaturedLoadingSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
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
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          color: AppColors.surface,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  height: 16,
                                  color: AppColors.surfaceVariant,
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 12,
                                  width: 100,
                                  color: AppColors.surfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildProductsSliver(List<Product> products) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => _navigateToProductDetail(product),
            showAddToCart: true,
          );
        },
      ),
    );
  }

  Widget _buildProductsLoadingSliver() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childCount: 6,
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

  Widget _buildErrorSliver(String error) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
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

  Widget _buildEmptySliver() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.onSurfaceSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Try changing the filters or search',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProductProvider>().clearSearch();
                context.read<ProductProvider>().selectCategory('all');
                context.read<ProductProvider>().changeFilter(ProductFilter.all);
              },
              child: Text('Clear filters'),
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
