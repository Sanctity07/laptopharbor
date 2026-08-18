import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final cred = await _authService.login(email: email, password: password);
      currentUser = await _authService.fetchUserProfile(cred.user!.uid);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _authService.signUp(name: name, email: email, password: password);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    notifyListeners();
  }
}
