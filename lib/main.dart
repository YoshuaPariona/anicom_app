import 'package:anicom_app/pages/login.dart';
import 'package:anicom_app/pages/register.dart';
import 'package:anicom_app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anicom_app/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => WelcomePage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      '/home': (context) => HomePage(),
    },
  ));
}
