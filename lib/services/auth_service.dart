// lib/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Servicio de autenticación para manejar el registro, inicio de sesión y cierre de sesión de usuarios.
/// Utiliza Firebase Authentication y Firestore para gestionar los datos de usuario.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instancia singleton de AuthService
  static final AuthService _instance = AuthService._internal();

  /// Fábrica para retornar la instancia singleton de AuthService.
  factory AuthService() => _instance;

  /// Constructor interno para crear la instancia singleton.
  AuthService._internal();

  /// Mapa de mensajes de error centralizados para manejar errores comunes de autenticación.
  static const Map<String, String> authErrors = {
    'email-already-in-use': 'El correo ya está registrado.',
    'invalid-email': 'Correo inválido.',
    'weak-password': 'La contraseña es demasiado débil (usa al menos 6 caracteres).',
    'network-request-failed': 'No hay conexión a internet. Por favor verifica tu conexión.',
    'user-not-found': 'No se encontró usuario con este correo electrónico.',
    'wrong-password': 'Contraseña incorrecta.',
  };

  /// Registra un nuevo usuario con correo y contraseña, y guarda sus datos adicionales en Firestore.
  ///
  /// [name] Nombre del usuario.
  /// [email] Correo electrónico del usuario.
  /// [password] Contraseña del usuario.
  /// Devuelve un `String?` con un mensaje de error en caso de fallo, o `null` si el registro es exitoso.
  Future<String?> register(String name, String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar datos adicionales del usuario en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
        'email': email.toLowerCase().trim(),
        'name': name.trim(),
      });

      return null; // Registro exitoso
    } on FirebaseAuthException catch (e) {
      return authErrors[e.code] ?? 'Error al registrar: ${e.message}';
    } catch (e) {
      if (e.toString().toLowerCase().contains('network')) {
        return authErrors['network-request-failed'];
      }
      return 'Error inesperado: ${e.toString()}';
    }
  }

  /// Inicia sesión con correo y contraseña.
  ///
  /// [email] Correo electrónico del usuario.
  /// [password] Contraseña del usuario.
  /// Devuelve un `String?` con un mensaje de error en caso de fallo, o `null` si el inicio de sesión es exitoso.
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return authErrors[e.code] ?? 'Correo electrónico o contraseña incorrectos.';
    } catch (e) {
      return 'Error inesperado: ${e.toString()}';
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Devuelve el usuario actual autenticado, si existe.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Obtiene los datos del usuario actual desde Firestore.
  ///
  /// Devuelve un `Future<DocumentSnapshot>` con los datos del usuario.
  /// Lanza una excepción si no hay usuario autenticado.
  Future<DocumentSnapshot> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("No hay usuario autenticado actualmente.");
    }
    return FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
  }
}
