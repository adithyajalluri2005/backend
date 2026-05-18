import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    required this.notificationsEnabled,
    required this.orderAlertsEnabled,
    required this.marketingAlertsEnabled,
    required this.themeMode,
    required this.language,
  });

  final bool notificationsEnabled;
  final bool orderAlertsEnabled;
  final bool marketingAlertsEnabled;
  final ThemeMode themeMode;
  final String language;

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? orderAlertsEnabled,
    bool? marketingAlertsEnabled,
    ThemeMode? themeMode,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      orderAlertsEnabled: orderAlertsEnabled ?? this.orderAlertsEnabled,
      marketingAlertsEnabled: marketingAlertsEnabled ?? this.marketingAlertsEnabled,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(
          const SettingsState(
            notificationsEnabled: true,
            orderAlertsEnabled: true,
            marketingAlertsEnabled: false,
            themeMode: ThemeMode.light,
            language: 'English',
          ),
        );

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void setOrderAlertsEnabled(bool value) {
    state = state.copyWith(orderAlertsEnabled: value);
  }

  void setMarketingAlertsEnabled(bool value) {
    state = state.copyWith(marketingAlertsEnabled: value);
  }

  void setDarkMode(bool value) {
    state = state.copyWith(themeMode: value ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
