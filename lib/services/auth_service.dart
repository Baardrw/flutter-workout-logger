import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pu_frontend/models/user.dart';
import 'package:pu_frontend/services/db_service.dart';

class AuthService {
  /// Service class for authentication

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  User? _getUserFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    // TODO : find a way to get the actual user display name here

    return User(user.uid, user.email, user.displayName);
  }

  /// Used by AuthWrapper to determine if user is logged in
  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_getUserFromFirebase);
  }

  Future<User?> get currentUser {
    return _dbService.getUser(_firebaseAuth.currentUser!.uid);
  }

  /// Called to sign in user
  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _getUserFromFirebase(credential.user);
  }

  /// Called to sign up user also adds user to firestore
  Future<User?> signUp(String email, String password, String name) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User u = User(credential.user!.uid, email, name);
    print('\n');
    print(u);
    print('\n');
    _dbService.addUser(u);

    return _getUserFromFirebase(credential.user);
  }

  /// Called to sign out user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String get uid {
    return _firebaseAuth.currentUser!.uid;
  }

}
