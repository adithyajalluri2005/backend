import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/features/auth/auth_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';
import 'package:vendor_app/shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageContainer(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: AppSpacing.giant),
                Text('Welcome Back!', style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.xs),
                Text('Login to manage your shop', style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.giant),
                Container(
                  height: AppSpacing.bannerHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    size: AppSpacing.iconHuge,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.giant),
                Text('Email Address', style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'merchant@example.com',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Password', style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: 'Login',
                  isBusy: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.register),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        Text('New to Local Vyapari? ', style: AppTextStyles.bodyMuted),
                        Text(
                          'Register Now',
                          style: AppTextStyles.body.copyWith(color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await ref.read(authProvider.notifier).login(email, password);

    if (!mounted) return;

    final authState = ref.read(authProvider);
    setState(() => _isLoading = false);

    if (authState.isLoggedIn) {
      context.go(AppRoutes.dashboard);
    } else if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error!)),
      );
    }
  }
}
