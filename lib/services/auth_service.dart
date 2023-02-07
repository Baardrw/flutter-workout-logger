import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pu_frontend/models/user.dart';

class AuthService {
  /// Service class for authentication

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _getUserFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  /// Used by AuthWrapper to determine if user is logged in
  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_getUserFromFirebase);
  }

  /// Called to sign in user
  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _getUserFromFirebase(credential.user);
  }

  /// Called to sign up user
  Future<User?> signUp(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _getUserFromFirebase(credential.user);
  }

  /// Called to sign out user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
