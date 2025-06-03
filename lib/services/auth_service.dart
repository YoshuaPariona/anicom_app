import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registrar(String nombre, String correo, String contrasena) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      // Guardar datos del usuario en Firestore
      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'correo': correo,
        'nombre': nombre,
      });

      return null; // éxito
    } on FirebaseAuthException catch (e) {
      return e.code; // error específico
    } catch (e) {
      return 'unknown'; // error no identificado
    }
  }

  Future<String?> login(String correo, String contrasena) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
      return null; // éxito
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'unknown';
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }
}
