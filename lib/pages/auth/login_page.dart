// lib/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/controllers/login_controller.dart';
import 'package:anicom_app/pages/home_page.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'package:anicom_app/widgets/custom_button.dart';
import 'package:anicom_app/widgets/custom_link_text.dart';
import 'package:anicom_app/widgets/custom_text_field.dart';
import 'package:anicom_app/widgets/logo_image.dart';

/// Página de inicio de sesión que permite a los usuarios autenticarse en la aplicación.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _loginController = LoginController(authService: authService);

    _emailController.addListener(() => _clearError('email'));
    _passwordController.addListener(() => _clearError('password'));
  }

  /// Limpia el mensaje de error de un campo específico.
  ///
  /// [field] El campo del cual se limpiará el error.
  void _clearError(String field) {
    setState(() {
      _loginController.clearError(field, field == 'email' ? _emailController : _passwordController);
    });
  }

  /// Construye y devuelve el widget del formulario de inicio de sesión.
  Widget _buildFormCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFDF4ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¡Bienvenido a Anicom!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          CustomTextField(
            label: 'Correo',
            controller: _emailController,
            errorText: _loginController.errors['email'],
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 18),
          CustomTextField(
            label: 'Contraseña',
            controller: _passwordController,
            isPassword: true,
            errorText: _loginController.errors['password'],
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 20),
          if (_loginController.errors['auth'] != null)
            Text(
              _loginController.errors['auth']!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 16),
          CustomButton(
            text: 'Iniciar Sesión',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleLogin,
          ),
          CustomLinkText(
            text: '¿No tienes una cuenta? ',
            linkText: 'Regístrate',
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
        ],
      ),
    );
  }

  /// Maneja el proceso de inicio de sesión cuando se presiona el botón de inicio de sesión.
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    String? error = await _loginController.handleLogin(_emailController, _passwordController);

    if (error == null) {
      setState(() {
        _loginController.errors['auth'] = null;
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      setState(() {
        _loginController.errors['auth'] = error;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE4F0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 50),
            LogoImage(),
            SizedBox(height: 30),
            Form(
              child: _buildFormCard(),
            ),
          ],
        ),
      ),
    );
  }
}
