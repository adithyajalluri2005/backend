import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vendor_app/core/constants/app_constants.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';
import 'package:vendor_app/features/auth/auth_provider.dart';
import 'package:vendor_app/features/settings/settings_provider.dart';
import 'package:vendor_app/shared/components/page_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Notifications', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Column(
                  children: <Widget>[
                    SwitchListTile.adaptive(
                      value: settings.notificationsEnabled,
                      activeColor: AppColors.primaryGreen,
                      title: Text('Notification settings', style: AppTextStyles.titleMedium),
                      subtitle: Text('Master switch for all vendor alerts', style: AppTextStyles.caption),
                      onChanged: notifier.setNotificationsEnabled,
                    ),
                    const Divider(height: AppSpacing.borderThin),
                    SwitchListTile.adaptive(
                      value: settings.orderAlertsEnabled,
                      activeColor: AppColors.primaryGreen,
                      title: Text('Inquiry alerts', style: AppTextStyles.titleMedium),
                      subtitle: Text('Get instant local notifications for new leads', style: AppTextStyles.caption),
                      onChanged: settings.notificationsEnabled ? notifier.setOrderAlertsEnabled : null,
                    ),
                    const Divider(height: AppSpacing.borderThin),
                    SwitchListTile.adaptive(
                      value: settings.marketingAlertsEnabled,
                      activeColor: AppColors.primaryGreen,
                      title: Text('Marketing alerts', style: AppTextStyles.titleMedium),
                      subtitle: Text('Receive promo and campaign suggestions', style: AppTextStyles.caption),
                      onChanged: settings.notificationsEnabled ? notifier.setMarketingAlertsEnabled : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Preferences', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: <Widget>[
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: settings.themeMode == ThemeMode.dark,
                        activeColor: AppColors.primaryGreen,
                        title: Text('Dark mode', style: AppTextStyles.titleMedium),
                        subtitle: Text('Switch the app theme instantly', style: AppTextStyles.caption),
                        onChanged: notifier.setDarkMode,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Language', style: AppTextStyles.titleMedium),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Select the preferred vendor language', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          DropdownButton<String>(
                            value: settings.language,
                            underline: const SizedBox.shrink(),
                            items: AppConstants.languages
                                .map(
                                  (String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (String? value) {
                              if (value == null) {
                                return;
                              }
                              notifier.setLanguage(value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Help & Support', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Column(
                  children: <Widget>[
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & support',
                      subtitle: AppConstants.supportEmail,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support center opened')),
                        );
                      },
                    ),
                    const Divider(height: AppSpacing.borderThin),
                    _SettingsTile(
                      icon: Icons.phone_outlined,
                      title: 'Call support',
                      subtitle: AppConstants.supportPhone,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support call triggered')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go(AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.danger),
                  label: Text(
                    'Logout',
                    style: AppTextStyles.body.copyWith(color: AppColors.danger),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.danger,
                      width: AppSpacing.borderThin,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTextStyles.titleMedium),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
