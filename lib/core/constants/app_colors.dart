import 'package:flutter/material.dart';

/// App color palette - green/mint theme cho grocery app
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2E7D32);       // Deep Green
  static const Color primaryLight = Color(0xFF4CAF50);  // Light Green
  static const Color primaryDark = Color(0xFF1B5E20);   // Dark Green
  static const Color primarySurface = Color(0xFFE8F5E9); // Very Light Green

  // Accent / Secondary
  static const Color accent = Color(0xFF00BFA5);        // Teal Mint
  static const Color accentLight = Color(0xFFE0F2F1);
  static const Color orange = Color(0xFFFF6D00);        // Flash sale orange
  static const Color yellow = Color(0xFFFFC107);        // Stars / rating

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0D0D0D);
  static const Color grey = Color(0xFF757575);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyExtraLight = Color(0xFFF5F5F5);
  static const Color greyBackground = Color(0xFFF8F9FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF1E88E5);

  // Order Status Colors
  static const Color statusPending = Color(0xFFFFA726);
  static const Color statusConfirmed = Color(0xFF42A5F5);
  static const Color statusPreparing = Color(0xFFAB47BC);
  static const Color statusShipping = Color(0xFF26C6DA);
  static const Color statusDelivered = Color(0xFF66BB6A);
  static const Color statusCompleted = Color(0xFF2E7D32);
  static const Color statusCancelled = Color(0xFFEF5350);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
