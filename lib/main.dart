import 'package:anicom_app/pages/home_page.dart';
import 'package:anicom_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'package:anicom_app/pages/welcome_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AniCom',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const WelcomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        // Otras rutas si tienes
      },
    );

  }
}
