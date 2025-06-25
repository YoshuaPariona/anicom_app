// lib/pages/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anicom_app/controllers/register_controller.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'package:anicom_app/widgets/custom_button.dart';
import 'package:anicom_app/widgets/custom_link_text.dart';
import 'package:anicom_app/widgets/custom_text_field.dart';

/// Página de registro que permite a los nuevos usuarios crear una cuenta en la aplicación.
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  late RegisterController _registerController;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _registerController = RegisterController(authService: authService);

    _usernameController.addListener(() => _clearError('username'));
    _emailController.addListener(() => _clearError('email'));
    _passwordController.addListener(() => _clearError('password'));
    _confirmPasswordController.addListener(() => _clearError('confirmPassword'));
  }

  /// Limpia el mensaje de error de un campo específico.
  ///
  /// [field] El campo del cual se limpiará el error.
  void _clearError(String field) {
    setState(() {
      _registerController.clearError(
          field,
          {
            'username': _usernameController,
            'email': _emailController,
            'password': _passwordController,
            'confirmPassword': _confirmPasswordController,
          }[field]!);
    });
  }

  /// Construye y devuelve el widget del formulario de registro.
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
            label: 'Usuario',
            controller: _usernameController,
            errorText: _registerController.errors['username'],
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 12),
          CustomTextField(
            label: 'Correo',
            controller: _emailController,
            errorText: _registerController.errors['email'],
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 12),
          CustomTextField(
            label: 'Contraseña',
            controller: _passwordController,
            errorText: _registerController.errors['password'],
            isPassword: true,
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 12),
          CustomTextField(
            label: 'Repetir contraseña',
            controller: _confirmPasswordController,
            errorText: _registerController.errors['confirmPassword'],
            isPassword: true,
            prefixIcon: Icons.lock_clock,
          ),
          SizedBox(height: 16),
          if (_registerController.errors['auth'] != null)
            Text(
              _registerController.errors['auth']!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 20),
          CustomButton(
            text: 'Registrarse',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _register,
          ),
          SizedBox(height: 10),
          CustomLinkText(
            text: '¿Ya tienes una cuenta? ',
            linkText: 'Inicia sesión',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  /// Maneja el proceso de registro cuando se presiona el botón de registro.
  Future<void> _register() async {
    if (!_registerController.validateFields(
        _usernameController, _emailController, _passwordController, _confirmPasswordController)) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
      _registerController.errors['auth'] = null;
    });

    String? error = await _registerController.handleRegister(
      _usernameController,
      _emailController,
      _passwordController,
    );

    if (error == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _registerController.errors['auth'] = error;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            Image.asset('assets/logo.png', width: 250),
            SizedBox(height: 30),
            _buildFormCard(),
          ],
        ),
      ),
    );
  }
}
