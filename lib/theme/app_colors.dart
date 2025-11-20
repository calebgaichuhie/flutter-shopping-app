// lib/theme/app_colors.dart
// Marketplace Dark Theme - Color Definitions
// Based on Material Design Dark Theme and Dribbble inspirations

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // === SURFACE COLORS (Material Design Base) ===
  /// Base surface color - #121212 (Material Design standard)
  static const Color surfaceBase = Color(0xFF121212);
  
  /// Main background color
  static const Color background = Color(0xFF121212);
  
  /// Default surface color for cards and components
  static const Color surface = Color(0xFF1E1E1E);
  
  /// Variant surface for secondary components
  static const Color surfaceVariant = Color(0xFF2C2C2C);

  // === BRAND COLORS (Inspired by Furniture Marketplace Design) ===
  /// Primary brand color - Gold/Bronze for CTAs and emphasis
  static const Color primary = Color(0xFFB08C47);
  
  /// Primary variant - Darker gold for hover states
  static const Color primaryVariant = Color(0xFF996F3B);
  
  /// Secondary color - Taupe gray for secondary elements
  static const Color secondary = Color(0xFF6C675E);
  
  /// Secondary variant - Dark chocolate brown
  static const Color secondaryVariant = Color(0xFF573E2A);

  // === TEXT COLORS (WCAG AA Compliant) ===
  /// Primary text on dark surfaces (87% white opacity)
  static const Color onSurface = Color(0xFFFFFFFF);
  
  /// Secondary text (60% white opacity)
  static const Color onSurfaceSecondary = Color(0x99FFFFFF);
  
  /// Disabled text (38% white opacity)
  static const Color onSurfaceDisabled = Color(0x61FFFFFF);
  
  /// Text on primary color backgrounds
  static const Color onPrimary = Color(0xFF000000);
  
  /// Text on secondary color backgrounds
  static const Color onSecondary = Color(0xFFFFFFFF);

  // === STATE COLORS ===
  /// Success color
  static const Color success = Color(0xFF4CAF50);
  
  /// Warning color
  static const Color warning = Color(0xFFFF9800);
  
  /// Error color (adapted for dark theme)
  static const Color error = Color(0xFFCF6679);
  
  /// Info color
  static const Color info = Color(0xFF2196F3);

  // === ELEVATION COLORS (Material Design Overlays) ===
  /// Surface with 1dp elevation (5% white overlay)
  static const Color elevation1dp = Color(0xFF1E1E1E);
  
  /// Surface with 4dp elevation (9% white overlay) - App Bars
  static const Color elevation4dp = Color(0xFF272727);
  
  /// Surface with 8dp elevation (11% white overlay) - Cards
  static const Color elevation8dp = Color(0xFF2D2D2D);
  
  /// Surface with 16dp elevation (14% white overlay) - Navigation
  static const Color elevation16dp = Color(0xFF343434);
  
  /// Surface with 24dp elevation (16% white overlay) - Dialogs
  static const Color elevation24dp = Color(0xFF383838);

  // === UTILITY COLORS ===
  /// Transparent color
  static const Color transparent = Colors.transparent;
  
  /// Semi-transparent overlay
  static const Color overlay = Color(0x80000000);
  
  /// Divider color
  static const Color divider = Color(0x1FFFFFFF);

  // === COLOR SCHEME GETTER ===
  /// Complete Material 3 ColorScheme for dark theme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryVariant,
    onPrimaryContainer: onSecondary,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryVariant,
    onSecondaryContainer: onSecondary,
    tertiary: info,
    onTertiary: onPrimary,
    error: error,
    onError: onPrimary,
    errorContainer: error.withOpacity(0.2),
    onErrorContainer: error,
    background: background,
    onBackground: onSurface,
    surface: surface,
    onSurface: onSurface,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: onSurfaceSecondary,
    outline: secondary.withOpacity(0.5),
    outlineVariant: secondary.withOpacity(0.2),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF1C1B1F),
    inversePrimary: Color(0xFF6750A4),
    surfaceTint: primary,
  );

  // === CONTRAST VALIDATION ===
  /// Validates WCAG AA contrast ratio (4.5:1 minimum)
  static bool isContrastValid(Color foreground, Color background) {
    final double contrast = _calculateContrast(foreground, background);
    return contrast >= 4.5;
  }

  /// Calculates contrast ratio between two colors
  static double _calculateContrast(Color color1, Color color2) {
    final double lum1 = _calculateLuminance(color1);
    final double lum2 = _calculateLuminance(color2);
    
    final double lighter = math.max(lum1, lum2);
    final double darker = math.min(lum1, lum2);
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculates relative luminance of a color
  static double _calculateLuminance(Color color) {
    final double r = _linearizeComponent(color.red / 255);
    final double g = _linearizeComponent(color.green / 255);
    final double b = _linearizeComponent(color.blue / 255);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearizes RGB component for luminance calculation
  static double _linearizeComponent(double component) {
    return component <= 0.03928
        ? component / 12.92
        : math.pow((component + 0.055) / 1.055, 2.4).toDouble();
  }
}

// === EXTENSION FOR ADDITIONAL COLOR UTILITIES ===
extension ColorExtensions on Color {
  /// Returns a color with specified opacity
  Color withOpacityFactor(double factor) {
    return withOpacity(opacity * factor);
  }

  /// Returns a lighter version of the color
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// Returns a darker version of the color
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// Returns true if this color is considered "dark"
  bool get isDark {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark;
  }
}
