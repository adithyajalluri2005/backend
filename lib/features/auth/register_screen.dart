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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Merchant'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageContainer(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Create Your Account', style: AppTextStyles.headline),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Join Local Vyapari to grow your business', style: AppTextStyles.bodyMuted),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  _FieldLabel(text: 'Full Name'),
                  TextFormField(
                    controller: _nameController,
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
                    decoration: const InputDecoration(hintText: 'John Doe'),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _FieldLabel(text: 'Email Address'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                    decoration: const InputDecoration(hintText: 'merchant@example.com'),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _FieldLabel(text: 'Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.length < 10) ? 'Enter a valid phone number' : null,
                    decoration: const InputDecoration(hintText: '9999990001'),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _FieldLabel(text: 'Password'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 8) ? 'Password must be 8+ chars' : null,
                    decoration: const InputDecoration(hintText: 'Minimum 8 characters'),
                  ),
                  const SizedBox(height: AppSpacing.giant),

                  PrimaryButton(
                    text: 'Register',
                    isBusy: _isLoading,
                    onPressed: _register,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          Text('Already have an account? ', style: AppTextStyles.bodyMuted),
                          Text(
                            'Login',
                            style: AppTextStyles.body.copyWith(color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref.read(authProvider.notifier).register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
    );

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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.titleMedium),
    );
  }
}
