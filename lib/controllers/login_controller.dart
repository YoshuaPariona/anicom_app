// lib/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:anicom_app/services/auth_service.dart';

/// Controlador para manejar la lógica de inicio de sesión.
/// Este controlador se encarga de la validación de campos y la autenticación del usuario.
class LoginController {
  final AuthService authService;

  /// Mapa para almacenar los mensajes de error asociados a los campos del formulario.
  Map<String, String?> errors = {
    'email': null,
    'password': null,
    'auth': null,
  };

  /// Constructor del controlador de inicio de sesión.
  ///
  /// [authService] Servicio de autenticación utilizado para manejar la lógica de autenticación.
  LoginController({required this.authService});

  /// Limpia el mensaje de error de un campo específico si el campo no está vacío.
  ///
  /// [field] El campo del cual se limpiará el error.
  /// [controller] Controlador del campo de texto asociado.
  void clearError(String field, TextEditingController controller) {
    if (errors[field] != null && controller.text.isNotEmpty) {
      errors[field] = null;
    }
  }

  /// Valida los campos de correo electrónico y contraseña.
  ///
  /// [emailController] Controlador del campo de correo electrónico.
  /// [passwordController] Controlador del campo de contraseña.
  /// Devuelve `true` si los campos son válidos, de lo contrario `false`.
  bool validateFields(TextEditingController emailController, TextEditingController passwordController) {
    bool isValid = true;

    if (emailController.text.isEmpty) {
      errors['email'] = 'Este campo no puede estar vacío';
      isValid = false;
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(emailController.text)) {
      errors['email'] = 'Formato de correo inválido';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      errors['password'] = 'Este campo no puede estar vacío';
      isValid = false;
    }

    return isValid;
  }

  /// Maneja el proceso de inicio de sesión.
  ///
  /// [emailController] Controlador del campo de correo electrónico.
  /// [passwordController] Controlador del campo de contraseña.
  /// Devuelve un `String?` con un mensaje de error en caso de fallo, o `null` si el inicio de sesión es exitoso.
  Future<String?> handleLogin(TextEditingController emailController, TextEditingController passwordController) async {
    if (validateFields(emailController, passwordController)) {
      return await authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
    }
    return "Por favor, complete el formulario correctamente.";
  }
}
