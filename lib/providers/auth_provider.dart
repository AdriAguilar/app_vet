import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/User.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  // Escuchar cambios en el estado de autenticación
  void listenToAuthState(BuildContext context) {
    _authService.userStream.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Registrar nuevo usuario
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    final user = await _authService.registerWithEmailAndPassword(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
    return user;
  }

  // Iniciar sesión
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final user = await _authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
    return user;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}