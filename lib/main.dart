import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/welcome_page.dart';
import 'pages/home/home_page.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
        },
        theme:  ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFA96B5A),         // Color del cursor
            selectionColor: Color(0xFFE8CFC7),      // Fondo de texto seleccionado
            selectionHandleColor: Color(0xFFA96B5A) // Gota o "handle"
          ),
        ),
      ),
    );
  }
}
