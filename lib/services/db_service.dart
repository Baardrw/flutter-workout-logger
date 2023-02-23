import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/models/user.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../models/session.dart';

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

  final _sessionRef = FirebaseFirestore.instance
      .collection('sessions')
      .withConverter(
        fromFirestore: (snapshot, _) => Session.fromJson(snapshot.data()!),
        toFirestore: (session, _) => session.toJson(),
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

  Future<void> addSession(Session session) async {
    return await _sessionRef.doc(session.id).set(session);
  }

  Future<void> updateSession(Session session) async {
    return await _sessionRef.doc(session.id).set(session);
  }

  Future<Session?> getSession(String id) async {
    return await _sessionRef.doc(id).get().then((value) => value.data());
  }

  Future<List<Session>> get sessions async {
    List<Session> ex = await _sessionRef
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    ex.sort((a, b) => b.date.compareTo(a.date));

    return ex;
  }

  Stream<Session> get sessionStream {
    return _sessionRef.snapshots().map((event) {
      return event.docs.map((e) => e.data()).toList().first;
    });
  }

  Future<bool> sessionExists(String id) async {
    return await _sessionRef.doc(id).get().then((value) => value.exists);
  }
}
