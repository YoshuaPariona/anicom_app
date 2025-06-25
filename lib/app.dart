// lib/app.dart
import 'dart:async';
import 'package:anicom_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'providers/cart_provider.dart';
import 'services/inactivity_service.dart';
import 'app_routes.dart';

/// Widget principal de la aplicación que gestiona el estado y el ciclo de vida de la app.
class MyApp extends StatefulWidget {
  /// Crea una instancia de [MyApp].
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// Estado para el widget [MyApp].
///
/// Esta clase maneja los eventos del ciclo de vida de la app, las interacciones del usuario
/// y la gestión de la sesión. Utiliza [InactivityService] para manejar la inactividad del usuario
/// y los tiempos de espera de la sesión.
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late InactivityService _inactivityService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inactivityService = InactivityService(
      onTimeout: () => _signOutWithMessage("Sesión cerrada por inactividad"),
      onWarningTimeout: _showInactivityWarningDialog,
      onInteraction: _handleUserInteraction,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inactivityService.start();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityService.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _inactivityService.start();
    } else if (state == AppLifecycleState.paused) {
      _inactivityService.cancel();
      _signOutWithMessage("Sesión cerrada por minimizar la app");
    }
  }

  /// Maneja las interacciones del usuario reiniciando el temporizador de inactividad.
  void _handleUserInteraction() {
    _inactivityService.reset();
  }

  /// Muestra un diálogo de advertencia cuando el usuario ha estado inactivo durante cierto período.
  void _showInactivityWarningDialog() {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Inactividad detectada'),
        content: const Text(
          'Serás desconectado en 30 segundos por inactividad.\n¿Deseas seguir conectado?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _inactivityService.reset();
            },
            child: const Text('Seguir conectado'),
          ),
        ],
      ),
    );
  }

  /// Cierra la sesión del usuario y muestra un mensaje.
  ///
  /// [message] El mensaje a mostrar después de cerrar sesión.
  Future<void> _signOutWithMessage(String message) async {
    final currentContext = navigatorKey.currentContext!;
    await FirebaseAuth.instance.signOut();

    navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);

    Future.delayed(const Duration(milliseconds: 500), () {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _handleUserInteraction(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: FirebaseAuth.instance.currentUser != null ? AppRoutes.home : AppRoutes.welcome,
          routes: {
            AppRoutes.welcome: (context) => const WelcomePage(),
            AppRoutes.login: (context) => LoginPage(),
            AppRoutes.register: (context) => RegisterPage(),
            AppRoutes.home: (context) => HomePage(),
          },
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFFA96B5A),
              selectionColor: Color(0xFFE8CFC7),
              selectionHandleColor: Color(0xFFA96B5A),
            ),
          ),
        ),
      ),
    );
  }
}
