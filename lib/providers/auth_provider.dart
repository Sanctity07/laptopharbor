import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? currentUser;
  AuthStatus status = AuthStatus.unknown;
  bool isLoading = false;
  String? errorMessage;

  AuthProvider() {
    // Firebase is guaranteed ready by the time AuthProvider is created
    // (LaptopHarborApp is only mounted after FutureBuilder resolves).
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      currentUser = null;
      status = AuthStatus.unauthenticated;
    } else {
      try {
        currentUser =
            await _authService.fetchUserProfile(firebaseUser.uid) ??
                AppUser(
                  uid: firebaseUser.uid,
                  name: firebaseUser.displayName ?? '',
                  email: firebaseUser.email ?? '',
                  photoUrl: firebaseUser.photoURL,
                );
      } catch (_) {
        // Firestore unavailable — fall back to Firebase Auth data
        currentUser = AppUser(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
        );
      }
      status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final cred =
          await _authService.login(email: email, password: password);
      currentUser =
          await _authService.fetchUserProfile(cred.user!.uid) ??
              AppUser(
                uid: cred.user!.uid,
                name: cred.user!.displayName ?? '',
                email: cred.user!.email ?? '',
                photoUrl: cred.user!.photoURL,
              );
      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
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
      currentUser = await _authService.signUp(
          name: name, email: email, password: password);
      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      errorMessage = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  String _friendlyError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found for that email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Check your connection.';
        default:
          return e.message ?? 'Authentication failed.';
      }
    }
    return e.toString();
  }
}
