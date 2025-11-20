// lib/screens/profile_screen.dart
// User profile screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserProfile(),
            SizedBox(height: 24),
            _buildStatsCards(),
            SizedBox(height: 24),
            _buildMenuOptions(context),
            SizedBox(height: 24),
            _buildAppInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.onPrimary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuario Demo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'frangelrcbarrera@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.onSurfaceSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Premium Customer',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _editProfile(),
              icon: Icon(Icons.edit),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Consumer2<CartProvider, ProductProvider>(
      builder: (context, cartProvider, productProvider, child) {
        final cartStats = cartProvider.getCartStats();
        final productStats = productProvider.getProductStats();

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Cart',
                '${cartStats['totalItems'] ?? 0}',
                'products',
                Icons.shopping_cart,
                AppColors.primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Favorites',
                '12',
                'productos',
                Icons.favorite,
                AppColors.error,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Pedidos',
                '7',
                'completed',
                Icons.receipt_long,
                AppColors.success,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuOption(
          title: 'Order History',
          subtitle: 'View all your previous orders',
          icon: Icons.history,
          onTap: () => _showComingSoon(context, 'Order History'),
        ),
        _buildMenuOption(
          title: 'Wishlist',
          subtitle: 'Products you like',
          icon: Icons.favorite_outline,
          onTap: () => _showComingSoon(context, 'Wishlist'),
        ),
        _buildMenuOption(
          title: 'Addresses',
          subtitle: 'Manage shipping addresses',
          icon: Icons.location_on_outlined,
          onTap: () => _showComingSoon(context, 'Address Management'),
        ),
        _buildMenuOption(
          title: 'Payment Methods',
          subtitle: 'Cards and payment methods',
          icon: Icons.payment,
          onTap: () => _showComingSoon(context, 'Payment Methods'),
        ),
        _buildMenuOption(
          title: 'Notifications',
          subtitle: 'Configure preferences',
          icon: Icons.notifications_outlined,
          onTap: () => _showComingSoon(context, 'Notification Settings'),
        ),
        _buildMenuOption(
          title: 'Help and Support',
          subtitle: 'Help center and contact',
          icon: Icons.help_outline,
          onTap: () => _showHelpDialog(context),
        ),
        _buildMenuOption(
          title: 'Terms and Conditions',
          subtitle: 'Privacy policy',
          icon: Icons.description_outlined,
          onTap: () => _showComingSoon(context, 'Terms and Conditions'),
        ),
        _buildMenuOption(
          title: 'Log Out',
          subtitle: 'Exit the application',
          icon: Icons.logout,
          iconColor: AppColors.error,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.onSurfaceSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.onSurfaceSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  size: 32,
                  color: AppColors.primary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Shopping App',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Flutter e-commerce application developed by Frangel Barrera as a portfolio project, with dark theme and connected to FakeStore API.',
              style: TextStyle(
                color: AppColors.onSurfaceSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _showComingSoon(context, 'Rate App'),
                  icon: Icon(Icons.star_outline),
                  label: Text('Rate'),
                ),
                TextButton.icon(
                  onPressed: () => _showComingSoon(context, 'Share App'),
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                ),
                TextButton.icon(
                  onPressed: () => _showComingSoon(context, 'Updates'),
                  icon: Icon(Icons.update),
                  label: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    // Implement profile editing
    print('Editar perfil');
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Push Notifications'),
              subtitle: Text('Receive offer notifications'),
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
            SwitchListTile(
              title: Text('Dark Theme'),
              subtitle: Text('Permanently enabled'),
              value: true,
              onChanged: null, // Deshabilitado ya que solo tenemos tema oscuro
            ),
            SwitchListTile(
              title: Text('Email Offers'),
              subtitle: Text('Receive promotions by email'),
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Help and Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help?'),
            SizedBox(height: 16),
            _buildHelpOption('📧 Email: frangelrcbarrera@gmail.com'),
            _buildHelpOption('📞 Teléfono: +1 (555) 123-4567'),
            _buildHelpOption('💬 Live chat: Available 24/7'),
            _buildHelpOption('❓ FAQ: Frequently asked questions'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showComingSoon(context, 'Chat de Soporte');
            },
            child: Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpOption(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Clear the cart when logging out
    context.read<CartProvider>().clearCart();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session closed successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
