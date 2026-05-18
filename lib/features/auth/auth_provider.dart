import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/network/auth_event_bus.dart';
import 'package:vendor_app/features/auth/auth_repository.dart';
import 'package:vendor_app/shared/models/user.dart';

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    this.user,
    this.isLoading = false,
    this.error,
  });

  final bool isLoggedIn;
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState(isLoggedIn: false)) {
    _checkAuthStatus();
    AuthEventBus.instance.authEvents.listen((loggedIn) {
      if (!loggedIn) {
        state = const AuthState(isLoggedIn: false);
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      state = state.copyWith(isLoggedIn: true);
      // Optionally fetch user profile
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _repository.login(email, password);
    if (response.success && response.data != null) {
      if (response.data!.role == 'USER') {
        state = state.copyWith(
          isLoading: false,
          error: 'Customers cannot login here. Please use the User application.',
        );
        return;
      }

      state = state.copyWith(
        isLoggedIn: true,
        user: response.data,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.fullMessage,
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = 'merchant',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );
    if (response.success) {
      state = state.copyWith(
        isLoggedIn: true,
        user: response.data,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.fullMessage,
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(isLoggedIn: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthNotifier(repository);
  },
);
