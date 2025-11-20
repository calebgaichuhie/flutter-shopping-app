// lib/widgets/custom_app_bar.dart
// Custom AppBar with search functionality

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final bool showSearch;
  final bool showCart;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.searchController,
    this.onSearchChanged,
    this.showSearch = true,
    this.showCart = true,
    this.actions,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 120 : 64);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching && widget.showSearch
          ? _buildSearchField()
          : Text(widget.title),
      automaticallyImplyLeading: !_isSearching,
      actions: _buildActions(),
      bottom: widget.showSearch && !_isSearching
          ? PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: _buildSearchSection(),
            )
          : null,
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];

    if (_isSearching) {
      // Button to close search
      actions.add(
        IconButton(
          icon: Icon(Icons.close),
          onPressed: _stopSearching,
        ),
      );
    } else {
      // Search button
      if (widget.showSearch) {
        actions.add(
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _startSearching,
          ),
        );
      }

      // Cart button with badge
      if (widget.showCart) {
        actions.add(_buildCartButton());
      }

      // Additional actions
      if (widget.actions != null) {
        actions.addAll(widget.actions!);
      }
    }

    return actions;
  }

  Widget _buildCartButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final itemCount = cartProvider.totalQuantity;
        
        return badges.Badge(
          badgeContent: Text(
            itemCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          showBadge: itemCount > 0,
          badgeStyle: badges.BadgeStyle(
            badgeColor: AppColors.error,
            elevation: 2,
          ),
          position: badges.BadgePosition.topEnd(top: 8, end: 8),
          child: IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: widget.searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search products...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.onSurfaceSecondary,
        ),
      ),
      style: TextStyle(
        color: AppColors.onSurface,
        fontSize: 16,
      ),
      onChanged: widget.onSearchChanged,
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: widget.searchController,
        decoration: InputDecoration(
          hintText: 'Search products, categories...',
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.onSurfaceSecondary,
          ),
          suffixIcon: widget.searchController?.text.isNotEmpty == true
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.onSurfaceSecondary,
                  ),
                  onPressed: () {
                    widget.searchController?.clear();
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!('');
                    }
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: TextStyle(
          color: AppColors.onSurface,
        ),
        onChanged: widget.onSearchChanged,
        onTap: _startSearching,
      ),
    );
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
    });
    _searchFocusNode.requestFocus();
  }

  void _stopSearching() {
    setState(() {
      _isSearching = false;
    });
    widget.searchController?.clear();
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!('');
    }
    _searchFocusNode.unfocus();
  }
}

/// Simplified AppBar for internal screens
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const SimpleAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}

/// AppBar with gradient for special pages
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color> gradientColors;
  final List<Widget>? actions;
  final bool showBackButton;

  const GradientAppBar({
    Key? key,
    required this.title,
    required this.gradientColors,
    this.actions,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}

/// AppBar with statistics for dashboard
class StatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const StatsAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceSecondary,
            ),
          ),
        ],
      ),
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
