// lib/widgets/bottom_nav_bar.dart
// Custom bottom navigation bar

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevation16dp,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                context: context,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: 'Categories',
                context: context,
              ),
              _buildCartNavItem(context),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Perfil',
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.onSurfaceSecondary,
                  size: 24,
                ),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.onSurfaceSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context) {
    final isSelected = currentIndex == 2;
    
    return Expanded(
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final itemCount = cartProvider.totalQuantity;
          
          return GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: badges.Badge(
                      badgeContent: Text(
                        itemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      showBadge: itemCount > 0,
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: AppColors.error,
                        elevation: 2,
                        padding: EdgeInsets.all(4),
                      ),
                      position: badges.BadgePosition.topEnd(top: -4, end: -4),
                      child: Icon(
                        isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                        color: isSelected 
                            ? AppColors.primary 
                            : AppColors.onSurfaceSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cart',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected 
                          ? AppColors.primary 
                          : AppColors.onSurfaceSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Navigation variant with FAB
class BottomNavBarWithFAB extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onFABPressed;

  const BottomNavBarWithFAB({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.onFABPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.elevation16dp,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home', context),
            _buildNavItem(1, Icons.grid_view_outlined, Icons.grid_view, 'Categories', context),
            SizedBox(width: 48), // Space for the FAB
            _buildCartNavItem(context),
            _buildNavItem(3, Icons.person_outline, Icons.person, 'Perfil', context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    BuildContext context,
  ) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected 
                  ? AppColors.primary 
                  : AppColors.onSurfaceSecondary,
              size: 24,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.onSurfaceSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context) {
    final isSelected = currentIndex == 2;
    
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final itemCount = cartProvider.totalQuantity;
        
        return GestureDetector(
          onTap: () => onTap(2),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                badges.Badge(
                  badgeContent: Text(
                    itemCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showBadge: itemCount > 0,
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: AppColors.error,
                    elevation: 2,
                    padding: EdgeInsets.all(4),
                  ),
                  position: badges.BadgePosition.topEnd(top: -4, end: -4),
                  child: Icon(
                    isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                    color: isSelected 
                        ? AppColors.primary 
                        : AppColors.onSurfaceSecondary,
                    size: 24,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Cart',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected 
                        ? AppColors.primary 
                        : AppColors.onSurfaceSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Minimal navigation for specific screens
class MinimalBottomNav extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const MinimalBottomNav({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                color: Colors.transparent,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.onSurfaceSecondary,
                  size: 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
