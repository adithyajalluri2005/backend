import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double giant = 48;

  static const double radiusXs = 6;
  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 18;
  static const double radiusXl = 24;

  static const double borderThin = 1;
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  static const double iconHuge = 72;

  static const double productImage = 84;
  static const double avatar = 48;
  static const double bannerHeight = 188;
  static const double bannerCompact = 120;
  static const double chartHeight = 220;
  static const double metricCardMinHeight = 128;
  static const double maxContentWidth = 720;
  static const double formBottomSpacing = 96;

  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.only(bottom: xxl);

  static const Duration shortAnimation = Duration(milliseconds: 180);
  static const Duration mediumAnimation = Duration(milliseconds: 260);
  static const Duration longAnimation = Duration(milliseconds: 420);
  static const Duration syncDelay = Duration(milliseconds: 850);
}
