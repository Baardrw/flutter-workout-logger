import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/models/user.dart';
import 'package:pu_frontend/services/auth_service.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _userRef =
      FirebaseFirestore.instance.collection('users').withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  final _excerciseRef = FirebaseFirestore.instance
      .collection('excercises')
      .withConverter(
        fromFirestore: (snapshot, _) => Excercise.fromJson(snapshot.data()!),
        toFirestore: (excercise, _) => excercise.toJson(),
      );

  Future<User?> getUser(String uid) async {
    return await _userRef.doc(uid).get().then((value) => value.data());
  }

  Future<void> updateUser(User user) async {
    return await _userRef.doc(user.uid).set(user);
  }

  Future<void> deleteUser(String uid) async {
    return await _userRef.doc(uid).delete();
  }

  Future<void> addUser(User user) async {
    return await _userRef.doc(user.uid).set(user);
  }

  Future<List<User>> get users {
    return _userRef
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<void> addExcercise(Excercise excercise) async {
    return await _excerciseRef.doc(excercise.name).set(excercise);
  }

  Future<void> updateExcercise(Excercise excercise) async {
    return await _excerciseRef.doc(excercise.name).set(excercise);
  }

  Future<Excercise?> getExcercise(String name) async {
    return await _excerciseRef.doc(name).get().then((value) => value.data());
  }

  Future<List<Excercise>> get excercises async {
    List<Excercise> ex = await _excerciseRef
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    ex.sort((a, b) => a.name.compareTo(b.name));

    return ex;
  }

  Stream<Excercise> get excerciseStream {
    return _excerciseRef.snapshots().map((event) {
      return event.docs.map((e) => e.data()).toList().first;
    });
  }

  Future<bool> excerciseExists(String name) async {
    return await _excerciseRef.doc(name).get().then((value) => value.exists);
  }

  Future<void> addLog(String excerciseName, Log log, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .doc(log.id)
        .set(log.toJson());
  }

  Future<void> updateLog(String excerciseName, Log log, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .doc(log.id)
        .set(log.toJson());
  }

  Future<void> deleteLog(String excerciseName, String logId, String uid) async {
    print("deleting log: $logId");

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .doc(logId)
        .delete();
  }

  Future<List<Log>> getLogs(String excerciseName, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .orderBy('date', descending: false)
        .get()
        .then((value) => value.docs
            .map((e) => Log.fromJson(e.data()))
            .toList()
            .reversed
            .toList());
  }

  Future<Log> getWeightLiftingPersonalRecord(
      String excerciseName, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .orderBy('weight', descending: true)
        .limit(1)
        .get()
        .then((value) =>
            value.docs.map((e) => Log.fromJson(e.data())).toList().first);
  }

  Future<Log> getCardioPersonalRecord(String excerciseName, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .orderBy('distance', descending: true)
        .limit(1)
        .get()
        .then((value) =>
            value.docs.map((e) => Log.fromJson(e.data())).toList().first);
  }

  Future<bool> logExists(String excerciseName, String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(excerciseName)
        .get()
        .then((value) => value.size > 0);
  }
}
