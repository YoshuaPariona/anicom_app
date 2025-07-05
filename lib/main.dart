// lib/main.dart
import 'package:anicom_app/app.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
