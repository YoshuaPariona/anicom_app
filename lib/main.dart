import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:anicom_app/pages/loginPage.dart';
import 'package:anicom_app/pages/registerPage.dart';
import 'package:anicom_app/pages/welcomePage.dart';
import 'package:anicom_app/pages/homepage.dart';
import 'package:anicom_app/providers/cartProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // aquí puedes agregar más providers si necesitas
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
        },
      ),
    ),
  );
}
