import 'package:anicom_app/pages/home/home_page.dart';
import 'package:anicom_app/widgets/custom_button.dart';
import 'package:anicom_app/widgets/custom_link_text.dart';
import 'package:anicom_app/widgets/custom_text_field.dart';
import 'package:anicom_app/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:anicom_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Map<String, String?> errors = {
    'email': null,
    'password': null,
    'auth': null,
  };

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => _clearError('email'));
    _passwordController.addListener(() => _clearError('password'));
  }

  void _clearError(String field) {
    final controller = field == 'email' ? _emailController : _passwordController;
    if (errors[field] != null && controller.text.isNotEmpty) {
      setState(() {
        errors[field] = null;
      });
    }
  }


  bool _validateFields() {
    bool isValid = true;

    setState(() {
      if (_emailController.text.isEmpty) {
        errors['email'] = 'Este campo no puede estar vacío';
        isValid = false;
      } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(_emailController.text)) {
        errors['email'] = 'Formato de correo inválido';
        isValid = false;
      }

      if (_passwordController.text.isEmpty) {
        errors['password'] = 'Este campo no puede estar vacío';
        isValid = false;
      }
    });

    return isValid;
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
              child: Container(
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
                      errorText: errors['email'],
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(height: 18),
                    CustomTextField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      isPassword: true,
                      errorText: errors['password'],
                      prefixIcon: Icons.lock,
                    ),
                    SizedBox(height: 20),
                    if (errors['auth'] != null)
                      Text(
                        errors['auth']!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 16),
                    CustomButton(
                      text: 'Iniciar Sesión',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : () async {
                        if (_validateFields()) {
                          setState(() => _isLoading = true);

                          final authService = AuthService();
                          String? error = await authService.login(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );

                          if (error == null) {
                            setState(() {
                              errors['auth'] = null;
                              _isLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          } else {
                            setState(() {
                              errors['auth'] = error;
                              _isLoading = false;
                            });
                          }
                        }
                      },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
