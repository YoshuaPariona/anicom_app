import 'package:flutter/material.dart';
import '../../widgets/logo_image.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _loginAsGuest(BuildContext context) async {
    const email = 'user@gmail.com';
    const password = 'password';

    final result = await AuthService().login(email, password);

    if (result == null) {
      // Login exitoso
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // Error en login
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

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

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () => _loginAsGuest(context),
              child: const Text('Ingresar como desarrollador'),
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
