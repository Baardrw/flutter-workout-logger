import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/models/user.dart';
import 'package:pu_frontend/services/auth_service.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService _authService = AuthService();

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<void> removeUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<void> editUser(User user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  Stream<List<User>> get users {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> addExcercise(Excercise excercise) async {
    await _firestore
        .collection('excercises')
        .doc(excercise.name)
        .set(excercise.toJson());
  }

  Future<void> removeExcercise(String name) async {
    await _firestore.collection('excercises').doc(name).delete();
  }

  Future<void> editExcercise(Excercise excercise) async {
    await _firestore
        .collection('excercises')
        .doc(excercise.name)
        .update(excercise.toJson());
  }
}
