import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        card: AppColors.cardBackground,
        primaryText: AppColors.textPrimary,
        secondaryText: AppColors.textSecondary,
        border: AppColors.borderColor,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        card: AppColors.darkCardBackground,
        primaryText: AppColors.darkTextPrimary,
        secondaryText: AppColors.darkTextSecondary,
        border: AppColors.darkBorderColor,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color card,
    required Color primaryText,
    required Color secondaryText,
    required Color border,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      primary: AppColors.primaryGreen,
      secondary: AppColors.secondaryGreen,
      surface: card,
      error: AppColors.danger,
      brightness: brightness,
    );

    final baseTextTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: AppTextStyles.display.copyWith(color: primaryText),
      headlineMedium: AppTextStyles.headline.copyWith(color: primaryText),
      titleLarge: AppTextStyles.sectionTitle.copyWith(color: primaryText),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: primaryText),
      bodyLarge: AppTextStyles.body.copyWith(color: primaryText),
      bodyMedium: AppTextStyles.bodyMuted.copyWith(color: secondaryText),
      bodySmall: AppTextStyles.caption.copyWith(color: secondaryText),
      labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
      labelMedium: AppTextStyles.caption.copyWith(color: secondaryText),
      labelSmall: AppTextStyles.micro.copyWith(color: secondaryText),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: baseTextTheme,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: AppSpacing.xxs,
        scrolledUnderElevation: AppSpacing.xxs,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryText, size: AppSpacing.iconLg),
        titleTextStyle: AppTextStyles.sectionTitle.copyWith(color: primaryText),
      ),
      cardTheme: CardThemeData(
        color: card,
        margin: EdgeInsets.zero,
        elevation: AppSpacing.xxs,
        shadowColor: Colors.black.withOpacity(brightness == Brightness.light ? 0.05 : 0.16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: border, width: AppSpacing.borderThin),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: AppSpacing.inputPadding,
        hintStyle: AppTextStyles.bodyMuted.copyWith(color: secondaryText),
        labelStyle: AppTextStyles.bodyMuted.copyWith(color: secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: border, width: AppSpacing.borderThin),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: border, width: AppSpacing.borderThin),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: AppSpacing.borderThin,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSpacing.xxs,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(
            color: AppColors.primaryGreen,
            width: AppSpacing.borderThin,
          ),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primaryGreen),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: AppColors.primaryGreen,
        secondarySelectedColor: AppColors.primaryGreen,
        side: BorderSide(color: border, width: AppSpacing.borderThin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        labelStyle: AppTextStyles.caption.copyWith(color: secondaryText),
        secondaryLabelStyle: AppTextStyles.caption.copyWith(color: Colors.white),
        padding: AppSpacing.chipPadding,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: AppSpacing.sm,
        selectedLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.primaryGreen),
        unselectedLabelStyle: AppTextStyles.caption.copyWith(color: secondaryText),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: primaryText,
        textColor: primaryText,
        tileColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
