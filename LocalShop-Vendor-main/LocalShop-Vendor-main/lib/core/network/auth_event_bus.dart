import 'dart:async';

class AuthEventBus {
  AuthEventBus._();
  static final instance = AuthEventBus._();

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get authEvents => _controller.stream;

  void logout() {
    _controller.add(false);
  }
}
