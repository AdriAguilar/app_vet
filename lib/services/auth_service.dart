import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import '../models/User.dart';

class AuthService {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;

  // Convertir FirebaseUser a User
  User? _userFromFirebase(fbAuth.User? user) {
    if (user == null) return null;
    return User(uid: user.uid, email: user.email!);
  }

  // Estado de autenticación en tiempo real
  Stream<User?> get userStream {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Registrar nuevo usuario
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('Error al registrar usuario: $e');
      return null;
    }
  }

  // Iniciar sesión
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
