import 'package:flutter/material.dart';
import 'package:anicom_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Map<String, String?> errors = {
    'username': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
    'auth': null,
  };

  bool _validateField(String field, String value) {
    setState(() => errors[field] = null);

    if (value.isEmpty) {
      errors[field] = 'Este campo no puede estar vacío';
      return false;
    }

    if (field == 'email' &&
        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      errors[field] = 'Formato de correo inválido';
      return false;
    }

    return true;
  }

  bool _validateFields() {
    final usernameValid = _validateField('username', _usernameController.text);
    final emailValid = _validateField('email', _emailController.text);
    final passwordValid = _validateField('password', _passwordController.text);
    final confirmValid =
        _validateField('confirmPassword', _confirmPasswordController.text);

    if (_passwordController.text != _confirmPasswordController.text) {
      errors['confirmPassword'] = 'Las contraseñas no coinciden';
      return false;
    }

    setState(() {}); // Actualiza los errores visuales
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
                    Text('¡Bienvenido a Anicom!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        errorText: errors['username'],
                      ),
                      onChanged: (_) => setState(() => errors['username'] = null),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        errorText: errors['email'],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() => errors['email'] = null),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        errorText: errors['password'],
                      ),
                      onChanged: (_) => setState(() => errors['password'] = null),
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Repetir contraseña',
                        errorText: errors['confirmPassword'],
                      ),
                      onChanged: (_) => setState(() => errors['confirmPassword'] = null),
                    ),
                    SizedBox(height: 16),
                    if (errors['auth'] != null)
                      Text(
                        errors['auth']!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_validateFields()) {
                                setState(() {
                                  _isLoading = true;
                                  errors['auth'] = null;
                                });

                                final error = await AuthService().registrar(
                                  _usernameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );

                                if (error == null) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                } else {
                                  setState(() {
                                    errors['auth'] =
                                        'No se pudo registrar: ${_parseAuthError(error)}';
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA96B5A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text('Registrarse'),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Regresar'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // TODO: Puedes personalizar aún más este parser de errores si deseas.
  String _parseAuthError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'El correo ya está registrado';
    }
    if (error.contains('weak-password')) {
      return 'La contraseña es demasiado débil';
    }
    if (error.contains('invalid-email')) {
      return 'Correo inválido';
    }
    return 'Error inesperado';
  }
}
