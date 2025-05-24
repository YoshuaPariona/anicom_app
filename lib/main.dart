import 'package:anicom_app/pages/login.dart';
import 'package:anicom_app/pages/register.dart';
import 'package:anicom_app/pages/welcome.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => WelcomePage(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
    },
  ));
}