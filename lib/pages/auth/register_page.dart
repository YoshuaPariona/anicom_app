import 'package:anicom_app/widgets/custom_link_text.dart';
import 'package:anicom_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:anicom_app/services/auth_service.dart';
import 'package:anicom_app/widgets/custom_button.dart';

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

  Map<String, String?> errors = {
    'username': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
    'auth': null,
  };

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() => _clearError('username'));
    _emailController.addListener(() => _clearError('email'));
    _passwordController.addListener(() => _clearError('password'));
    _confirmPasswordController.addListener(() => _clearError('confirmPassword'));
  }

  void _clearError(String field) {
    final controller = {
      'username': _usernameController,
      'email': _emailController,
      'password': _passwordController,
      'confirmPassword': _confirmPasswordController,
    }[field]!;

    if (errors[field] != null && controller.text.isNotEmpty) {
      setState(() {
        errors[field] = null;
      });
    }
  }

  bool _validateField(String field, String value) {
    if (value.isEmpty) {
      setState(() => errors[field] = 'Este campo no puede estar vacío');
      return false;
    }

    if (field == 'email' &&
        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      setState(() => errors[field] = 'Formato de correo inválido');
      return false;
    }

    return true;
  }

  bool _validateFields() {
    bool usernameValid = _validateField('username', _usernameController.text);
    bool emailValid = _validateField('email', _emailController.text);
    bool passwordValid = _validateField('password', _passwordController.text);
    bool confirmValid = _validateField('confirmPassword', _confirmPasswordController.text);

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errors['confirmPassword'] = 'Las contraseñas no coinciden';
      });
      confirmValid = false;
    }

    return usernameValid && emailValid && passwordValid && confirmValid;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
      errors['auth'] = null;
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final error = await AuthService().register(
      username,
      email,
      password,
    );

    if (error == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        errors['auth'] = error;
        _isLoading = false;
      });
    }
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
            Container(
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
                    errorText: errors['username'],
                    prefixIcon: Icons.person,
                  ),

                  SizedBox(height: 12),

                  CustomTextField(
                    label: 'Correo',
                    controller: _emailController,
                    errorText: errors['email'],
                    textColor: Colors.black,
                    prefixIcon: Icons.email,
                  ),

                  SizedBox(height: 12),

                  CustomTextField(
                    label: 'Contraseña',
                    controller: _passwordController,
                    errorText: errors['password'],
                    isPassword: true,
                    prefixIcon: Icons.lock,
                  ),

                  SizedBox(height: 12),

                  CustomTextField(
                    label: 'Repetir contraseña',
                    controller: _confirmPasswordController,
                    errorText: errors['confirmPassword'],
                    isPassword: true,
                    prefixIcon: Icons.lock_clock,
                  ),
                  SizedBox(height: 16),
                  if (errors['auth'] != null)
                    Text(
                      errors['auth']!,
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
            ),
          ],
        ),
      ),
    );
  }
}
