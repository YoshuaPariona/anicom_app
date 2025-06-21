import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// Clave global para navegación
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  Timer? _warningTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInactivityTimer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelTimers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startInactivityTimer();
    } else if (state == AppLifecycleState.paused) {
      _cancelTimers();
      _signOutWithMessage("Sesión cerrada por minimizar la app");
    }
  }

  void _handleUserInteraction() {
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _cancelTimers();
    _inactivityTimer = Timer(const Duration(seconds: 30), () {
      _showInactivityWarningDialog();
    });
  }

  void _cancelTimers() {
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
  }

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
              _startInactivityTimer();
            },
            child: const Text('Seguir conectado'),
          ),
        ],
      ),
    );

    _warningTimer = Timer(const Duration(seconds: 30), () {
      Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
      _signOutWithMessage("Sesión cerrada por inactividad");
    });
  }

  Future<void> _signOutWithMessage(String message) async {
    await FirebaseAuth.instance.signOut();

    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);

      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
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
          initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
          routes: {
            '/': (context) => const WelcomePage(),
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/home': (context) => HomePage(),
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
