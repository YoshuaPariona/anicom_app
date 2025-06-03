import 'package:flutter/material.dart';
import '../../widgets/logo_image.dart';
import '../../widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "¡BIENVENIDO!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const LogoImage(),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Ingresar',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
