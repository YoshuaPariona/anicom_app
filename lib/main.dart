// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'app.dart';

// Clave global para navegación
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Función principal que inicializa y ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
