import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: PageContainer(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Container(
                  height: AppSpacing.iconHuge * 2,
                  width: AppSpacing.iconHuge * 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront,
                    size: AppSpacing.iconHuge,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.giant),
                Text(
                  'Local Vyapari\nPartner',
                  style: AppTextStyles.display.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Grow your shop.\nReach nearby customers.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: Colors.white.withOpacity(0.92)),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Get Started',
                  backgroundColor: AppColors.secondaryGreen,
                  onPressed: () => context.go(AppRoutes.login),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  text: 'Login',
                  isOutlined: true,
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                  onPressed: () => context.go(AppRoutes.login),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
