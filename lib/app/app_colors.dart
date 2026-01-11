import 'package:flutter/material.dart';

/// Modern color palette for StudyMatch - Matching logo colors
class AppColors {
  // Primary colors - Logo blue (Study)
  static const Color primaryBlue = Color(0xFF2196F3); // Bright blue from logo
  static const Color primaryBlueDark = Color(0xFF1976D2); // Darker blue outline
  static const Color primaryBlueLight = Color(0xFF64B5F6); // Lighter blue

  // Secondary colors - Logo pink/magenta (Match)
  static const Color secondaryPink = Color(0xFFE91E63); // Vibrant pink/magenta from logo
  static const Color secondaryPinkDark = Color(0xFFC2185B); // Darker pink outline
  static const Color secondaryPinkLight = Color(0xFFF48FB1); // Lighter pink

  // Action colors - Like/Dislike (matching logo)
  static const Color likeColor = Color(0xFFE91E63); // Match pink from logo
  static const Color likeColorLight = Color(0xFFF48FB1);
  static const Color dislikeColor = Color(0xFF64748B); // Modern gray
  static const Color dislikeColorDark = Color(0xFF475569);

  // Background colors - matching logo gradient
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure white
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF5F7FA); // Very light gray-blue
  static const Color backgroundGradientStart = Color(0xFFE3F2FD); // Light blue tint
  static const Color backgroundGradientEnd = Color(0xFFFCE4EC); // Light pink tint

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Accent colors
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentYellow = Color(0xFFF59E0B);

  // Outline colors
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // Gradient colors - matching logo heart split
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient likeGradient = LinearGradient(
    colors: [likeColor, likeColorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Logo heart gradient (split down the middle)
  static const LinearGradient logoHeartGradient = LinearGradient(
    colors: [primaryBlue, secondaryPink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

