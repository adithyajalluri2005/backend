import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_app/core/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const double displaySize = 40;
  static const double headlineSize = 28;
  static const double sectionSize = 18;
  static const double titleSize = 16;
  static const double bodySize = 14;
  static const double captionSize = 12;
  static const double badgeSize = 11;
  static const double microSize = 10;

  static TextStyle get display => GoogleFonts.inter(
        fontSize: displaySize,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  static TextStyle get headline => GoogleFonts.inter(
        fontSize: headlineSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: sectionSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: titleSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: titleSize,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: bodySize,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyMuted => GoogleFonts.inter(
        fontSize: bodySize,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: captionSize,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get badge => GoogleFonts.inter(
        fontSize: badgeSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: titleSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get micro => GoogleFonts.inter(
        fontSize: microSize,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );
}
