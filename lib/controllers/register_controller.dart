// lib/controllers/register_controller.dart
import 'package:flutter/material.dart';
import 'package:anicom_app/services/auth_service.dart';

/// Controlador para manejar la lógica de registro.
class RegisterController {
  final AuthService authService;

  /// Mapa para almacenar los mensajes de error asociados a los campos del formulario.
  Map<String, String?> errors = {
    'username': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
    'auth': null,
  };

  /// Constructor del controlador de registro.
  ///
  /// [authService] Servicio de autenticación utilizado para manejar la lógica de autenticación.
  RegisterController({required this.authService});

  /// Limpia el mensaje de error de un campo específico si el campo no está vacío.
  ///
  /// [field] El campo del cual se limpiará el error.
  /// [controller] Controlador del campo de texto asociado.
  void clearError(String field, TextEditingController controller) {
    if (errors[field] != null && controller.text.isNotEmpty) {
      errors[field] = null;
    }
  }

  /// Valida un campo específico.
  ///
  /// [field] El campo a validar.
  /// [value] El valor del campo.
  /// Devuelve `true` si el campo es válido, de lo contrario `false`.
  bool validateField(String field, String value) {
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

  /// Valida todos los campos del formulario.
  ///
  /// [usernameController] Controlador del campo de usuario.
  /// [emailController] Controlador del campo de correo electrónico.
  /// [passwordController] Controlador del campo de contraseña.
  /// [confirmPasswordController] Controlador del campo de confirmación de contraseña.
  /// Devuelve `true` si todos los campos son válidos, de lo contrario `false`.
  bool validateFields(
      TextEditingController usernameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) {
    bool usernameValid = validateField('username', usernameController.text);
    bool emailValid = validateField('email', emailController.text);
    bool passwordValid = validateField('password', passwordController.text);
    bool confirmValid = validateField('confirmPassword', confirmPasswordController.text);

    if (passwordController.text != confirmPasswordController.text) {
      errors['confirmPassword'] = 'Las contraseñas no coinciden';
      confirmValid = false;
    }

    return usernameValid && emailValid && passwordValid && confirmValid;
  }

  /// Maneja el proceso de registro.
  ///
  /// [usernameController] Controlador del campo de usuario.
  /// [emailController] Controlador del campo de correo electrónico.
  /// [passwordController] Controlador del campo de contraseña.
  /// Devuelve un `String?` con un mensaje de error en caso de fallo, o `null` si el registro es exitoso.
  Future<String?> handleRegister(
      TextEditingController usernameController,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    return await authService.register(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );
  }
}
