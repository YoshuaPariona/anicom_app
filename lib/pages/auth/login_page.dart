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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Variable para gestionar el estado de carga del botón
  bool _isLoading = false;

  Map<String, String?> errors = {
    'email': null,
    'password': null,
    'auth': null,
  };

  // Refactorizamos la validación para manejar errores de manera global.
  bool _validateField(String field, String value) {
    setState(() {
      errors[field] = null;
    });

    if (value.isEmpty) {
      errors[field] = 'Este campo no puede estar vacío';
      return false;
    }

    if (field == 'email' && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      errors[field] = 'Formato de correo inválido';
      return false;
    }

    return true;
  }

  // Llamar a la validación global para todos los campos.
  bool _validateFields() {
    setState(() {
      errors['email'] = _validateField('email', _emailController.text) ? null : errors['email'];
      errors['password'] = _validateField('password', _passwordController.text) ? null : errors['password'];
    });

    return errors['email'] == null && errors['password'] == null;
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
              key: _formKey,
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
                    // Campo de correo con validación en tiempo real
                    CustomTextField(
                      label: 'Correo',
                      controller: _emailController,
                      errorText: errors['email'],
                      onChanged: (value) {
                        setState(() {
                          errors['email'] = null;
                        });
                      },
                      validator: (value) {
                        if (value != null && !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                          return 'Formato de correo inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 18),
                    // Campo de contraseña con validación en tiempo real
                    CustomTextField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      isPassword: true,
                      errorText: errors['password'],
                      onChanged: (value) {
                        setState(() {
                          errors['password'] = null;
                        });
                      },
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
                      onPressed: () async {
                        if (_validateFields()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String? error = await AuthService().login(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );

                          if (error == null) {
                            setState(() {
                              errors['auth'] = null;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomePage()),
                            );
                          } else {
                            setState(() {
                              errors['auth'] = 'El correo o la contraseña no son correctos.';
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
