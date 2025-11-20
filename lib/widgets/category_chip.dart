// lib/widgets/category_chip.dart
// Widget to display categories as selectable chips

import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCount;
  final int? productCount;

  const CategoryChip({
    Key? key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.showCount = false,
    this.productCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category icon
            _buildCategoryIcon(),
            SizedBox(height: 8),
            
            // Category name
            _buildCategoryName(context),
            
            // Product counter (optional)
            if (showCount && productCount != null) ...[
              SizedBox(height: 4),
              _buildProductCount(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final backgroundColor = isSelected 
        ? category.getThemeColor()
        : AppColors.surface;
        
    final iconColor = isSelected 
        ? Colors.white
        : category.getThemeColor();

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.getThemeColor().withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: category.getThemeColor().withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Icon(
        category.icon,
        size: 28,
        color: iconColor,
      ),
    );
  }

  Widget _buildCategoryName(BuildContext context) {
    return Container(
      width: 80,
      child: Text(
        category.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? category.getThemeColor() : AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProductCount(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: category.getThemeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$productCount',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: category.getThemeColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Alternative widget for categories in horizontal list
class CategoryChipHorizontal extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;
  final int? productCount;

  const CategoryChipHorizontal({
    Key? key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.productCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? category.getThemeColor()
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: category.getThemeColor().withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.getThemeColor().withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: isSelected 
                  ? Colors.white 
                  : category.getThemeColor(),
            ),
            SizedBox(width: 8),
            Text(
              category.displayName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected 
                    ? Colors.white 
                    : AppColors.onSurface,
              ),
            ),
            if (productCount != null) ...[
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.2)
                      : category.getThemeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$productCount',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected 
                        ? Colors.white 
                        : category.getThemeColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget to display categories in a compact grid
class CategoryGridItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;
  final int? productCount;

  const CategoryGridItem({
    Key? key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.productCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected 
                ? category.getGradient()
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 40,
                  color: category.getThemeColor(),
                ),
                SizedBox(height: 12),
                Text(
                  category.displayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (productCount != null) ...[
                  SizedBox(height: 4),
                  Text(
                    '$productCount product${productCount! != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
