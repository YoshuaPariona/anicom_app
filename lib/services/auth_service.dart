import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Registra un nuevo usuario con correo y contraseña, y guarda sus datos en Firestore
  Future<String?> register(String name, String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardamos datos adicionales del usuario en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
        'email': email.toLowerCase().trim(),
        'name': name.trim(),
      });

      return null; // Registro exitoso

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'El correo electrónico ya está registrado.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'weak-password':
          return 'La contraseña es demasiado débil (usa al menos 6 caracteres).';
        default:
          if (e.message != null && e.message!.contains('network error')) {
            return 'No hay conexión a internet. Por favor verifica tu conexión.';
          }
          return 'Error al registrar: ${e.message}';
      }
    } catch (e) {
      if (e.toString().toLowerCase().contains('network')) {
        return 'No hay conexión a internet. Por favor verifica tu conexión.';
      }
      return 'Error inesperado: ${e.toString()}';
    }
  }

  // Inicia sesión con correo y contraseña
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        return 'No hay conexión a internet. Por favor, verifica tu conexión.';
      }
      return 'Correo electrónico o contraseña incorrectos.';
    } catch (e) {
      return 'Error inesperado: ${e.toString()}';
    }
  }

  // Cierra la sesión del usuario actual
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Devuelve el usuario actual autenticado (si existe)
  User? getCurrentUser() {
    return _auth.currentUser;
  }

}
