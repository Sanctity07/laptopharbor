import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AppUser> signUp({required String name, required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = AppUser(uid: cred.user!.uid, name: name, email: email);
    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  Future<UserCredential> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() => _auth.signOut();

  Future<AppUser?> fetchUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  Future<void> updateProfile(AppUser user) {
    return _db.collection('users').doc(user.uid).update(user.toMap());
  }
}
