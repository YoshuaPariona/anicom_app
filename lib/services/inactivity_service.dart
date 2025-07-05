// lib/services/inactivity_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InactivityService with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey;
  final Duration inactivityDuration;
  final Duration warningDuration;
  Timer? _inactivityTimer;
  Timer? _warningTimer;
  String? _currentRoute;
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  InactivityService({
    required this.navigatorKey,
    this.inactivityDuration = const Duration(minutes: 2, seconds: 0),
    this.warningDuration = const Duration(seconds: 30),
  });

  void start({String? initialRoute}) {
    WidgetsBinding.instance.addObserver(this);
    _currentRoute = initialRoute;
    debugPrint('[Inactivity] Service started with initial route: $_currentRoute');
    _startInactivityTimer();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelTimers();
  }

  void handleUserInteraction() {
    debugPrint('[Inactivity] User interaction detected.');
    _startInactivityTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[Inactivity] App resumed.');
      _startInactivityTimer();
    } else if (state == AppLifecycleState.paused) {
      debugPrint('[Inactivity] App paused.');
      _cancelTimers();
      _signOutWithMessage("Sesión cerrada por minimizar la app");
    }
  }

  void updateCurrentRoute(String? routeName) {
    if (routeName == null) {
      debugPrint('[Inactivity] Route is null, ignoring update.');
      return;
    }
    debugPrint('[Inactivity] Route changed to: $routeName');
    _currentRoute = routeName;
    _startInactivityTimer();
  }

  bool _shouldIgnoreInactivity() {
    bool shouldIgnore = _currentRoute == '/login' ||
                        _currentRoute == '/register' ||
                        _currentRoute == '/welcome';
    debugPrint('[Inactivity] Should ignore inactivity: $shouldIgnore');
    return shouldIgnore;
  }

  void _startInactivityTimer() {
    if (_shouldIgnoreInactivity()) {
      debugPrint('[Inactivity] Ignored due to current route: $_currentRoute');
      _cancelTimers();
      return;
    }
    debugPrint('[Inactivity] Timer started for route: $_currentRoute');
    _cancelTimers();
    _inactivityTimer = Timer(inactivityDuration, _showInactivityWarningDialog);
  }

  void _cancelTimers() {
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
  }

  void _showInactivityWarningDialog() {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;
    debugPrint('[Inactivity] Showing warning dialog.');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Inactividad detectada'),
        content: const Text(
          'Serás desconectado en breve por inactividad.\n¿Deseas seguir conectado?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startInactivityTimer();
            },
            child: const Text('Seguir conectado'),
          ),
        ],
      ),
    );
    _warningTimer = Timer(warningDuration, () {
      if (navigatorKey.currentState?.overlay?.context != null) {
        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      }
      _signOutWithMessage("Sesión cerrada por inactividad");
    });
  }

  Future<void> _signOutWithMessage(String message) async {
    debugPrint('[Inactivity] Signing out...');
    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/welcome', (route) => false);
    Future.delayed(const Duration(milliseconds: 500), () {
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }
}
