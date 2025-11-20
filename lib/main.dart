// lib/main.dart
// Main entry point for the E-Commerce Flutter App - Portfolio Project by Frangel Barrera

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';

// Theme
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/profile_screen.dart';

// Widgets
import 'widgets/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure screen orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure status bar style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Shopping App',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Navigation configuration
        home: MainScreen(),
        routes: {
          '/home': (context) => MainScreen(),
          '/cart': (context) => CartScreen(),
          '/categories': (context) => CategoriesScreen(),
          '/profile': (context) => ProfileScreen(),
        },

        // Localization configuration
        locale: Locale('en', 'US'),

        // Builder for global UI error handling
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // Prevent system text scaling
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  // List of main screens
  final List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize providers after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializeProviders() {
    // Initialize product provider
    context.read<ProductProvider>().initialize().catchError((error) {
      _showErrorSnackBar('Error loading data: $error');
    });

    // Load saved cart (if exists)
    context.read<CartProvider>().loadCart().catchError((error) {
      debugPrint('Error loading cart: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            context.read<ProductProvider>().refresh();
          },
        ),
      ),
    );
  }
/// Splash screen (optional)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();

    // Navigate to main screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: AppColors.onPrimary,
                      ),
                    ),
                    SizedBox(height: 32),

                    // App name
                    Text(
                      'Flutter Shopping App',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Your favorite online store',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceSecondary,
                      ),
                    ),
                    SizedBox(height: 48),

                    // Loading indicator
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
/// Global error handling
class ErrorHandler {
  static void handleError(dynamic error, StackTrace stackTrace) {
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');

    // In production, send errors to analytics service
    // For example: Crashlytics, Sentry, etc.
  }
}

/// App configuration
class AppConfig {
  static const String appName = 'Flutter Shopping App';
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  
  // API URLs
  static const String apiBaseUrl = 'https://fakestoreapi.com';
  
  // Application configurations
  static const bool enableAnalytics = false;
  static const bool enableCrashlytics = false;
  static const bool enableLogging = true;
  
  // UI configurations
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
