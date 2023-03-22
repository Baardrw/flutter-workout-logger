import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pu_frontend/models/excercise.dart';
import 'package:pu_frontend/models/user.dart';
import 'package:pu_frontend/services/auth_service.dart';

import '../models/group.dart';
import '../models/program.dart';
import '../models/session.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<void> deleteUser(User user) async {
    return await _userRef.doc(user.uid).delete();
  }

  Future<void> addUser(User user) async {
    return await _userRef.doc(user.uid).set(user);
  }

  Future<List<User>> get users {
    return _userRef
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<List<User>> getUsersByUsername(String username) {
    return _userRef
        .where("name", isEqualTo: username)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<void> addExcercise(Excercise excercise) async {
    return await _excerciseRef.doc(excercise.name).set(excercise);
  }

  Future<void> updateExcercise(Excercise excercise) async {
    return await _excerciseRef.doc(excercise.name).set(excercise);
  }

  Future<void> deleteExcercise(Excercise excercise) async {
    return await _excerciseRef.doc(excercise.name).delete();
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

  Future<List<Excercise>> getExcercisesUserHasDone(String uid) async {
    List<String> excercises = [];

    List<Session> sessions = await getSessions(uid);

    for (Session session in sessions) {
      session.excercises!.forEach((element) {
        if (!excercises.contains(element)) {
          excercises.add(element);
        }
      });
    }

    List<Excercise> excerciseObjects = [];

    for (String excercise in excercises) {
      Excercise? excerciseObject = await getExcercise(excercise);

      if (excerciseObject != null) {
        excerciseObjects.add(excerciseObject);
      }
    }

    return excerciseObjects;
  }

  Future<void> addLog(Log log, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(log.excerciseName)
        .doc(log.id)
        .set(log.toJson());
  }

  Future<void> updateLog(Log log, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(log.excerciseName)
        .doc(log.id)
        .set(log.toJson());
  }

  Future<void> deleteLog(String logId, String excerciseName, String uid) async {
    print("deleting log: ${logId}");

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

  Future<void> addSession(Session session, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session.id)
        .set(session.toJson());
  }

  Future<void> updateSession(Session session, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session.id)
        .set(session.toJson());
  }

  Future<void> deleteSession(Session session, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session.id)
        .delete();
  }

  Future<Session> getSession(String session, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session)
        .get()
        .then((value) => Session.fromJson(value.data()!));
  }

  Future<List<Session>> getSessions(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('date', descending: true)
        .get()
        .then((value) => value.docs
        .map((e) => Session.fromJson(e.data()))
        .toList()
        .reversed
        .toList());
  }

  Future<List<Session>> getSessionsFriend(String uid) async {
    var friends = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((doc) => doc.get('freinds'));

    List<Session> allSessions = [];

    for (var friendId in friends) {
      var sessions = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('sessions')
          .orderBy('date', descending: true)
          .get();
      for (var sessionDoc in sessions.docs) {
        var sessionData = sessionDoc.data();
        // Get the completed instances for the session
        var instancesQuery = await sessionDoc.reference
            .collection('instances')
            .where('completed', isEqualTo: true)
            .get();
        var completedInstances = instancesQuery.docs
            .map((doc) => SessionInstance.fromJson(doc.data()))
            .toList();

        // Only include the session if it has at least one completed instance
        if (completedInstances.isNotEmpty) {
          var session = Session.fromJson(sessionData);
          allSessions.add(session);
        }
      }
    }

    return allSessions.reversed.toList();
  }

  Stream<Session> getSessionStream(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Session.fromJson(e.data())).toList().first;
    });
  }

  Stream<Session> getSessionStreamFriends(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((doc) => doc.get('freinds'))
        .then((friendIds) => Future.wait(friendIds.map((friendId) => getSessionStream(friendId))))
        .asStream()
        .flatMap((sessions) => Stream.fromIterable(sessions as Iterable<Session>));
  }

  Future<void> addSessionInstance(
      SessionInstance sessionInstance, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessionInstance.sessionId)
        .collection('instances')
        .doc(sessionInstance.id)
        .set(sessionInstance.toJson());
  }

  Future<void> updateSessionInstance(
      SessionInstance sessionInstance, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessionInstance.sessionId)
        .collection('instances')
        .doc(sessionInstance.id)
        .set(sessionInstance.toJson());
  }

  Future<void> deleteSessionInstance(
      SessionInstance sessionInstance, String uid) async {
    List<String> excercises = sessionInstance.excercises ?? [];

    for (String excercise in excercises) {
      // Deletes all logs for this session instance
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(excercise)
          .where('sessionId', isEqualTo: sessionInstance.id)
          .get()
          .then((value) => value.docs.forEach((element) {
        element.reference.delete();
      }));
    }

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessionInstance.sessionId)
        .collection('instances')
        .doc(sessionInstance.id)
        .delete();
  }

  Future<int> getSessionCount(String uid) async {
    int profileCount = 0;

    var sessions = await _userRef.doc(uid).collection('sessions').get();

    for (var element in sessions.docs) {
      var instances = await _userRef
          .doc(uid)
          .collection('sessions')
          .doc(element.id)
          .collection('instances')
          .get();
      profileCount += instances.docs.length;
      print("instances:   ${instances.docChanges.length}");
    }

    return profileCount;
  }

  Future<List<SessionInstance>> getInstancesOfSession(
      String sessionId, String uid) async {
    try {
      List<SessionInstance> s = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('sessions')
          .doc(sessionId)
          .collection('instances')
          .get()
          .then((value) => value.docs
          .map((e) => SessionInstance.fromJson(e.data()))
          .toList()
          .reversed
          .toList());

      print('instances: ${s.isEmpty}');

      return s;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addProgram(Program program, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('programs')
        .doc(program.id)
        .set(program.toJson());
  }

  Future<void> updateProgram(Program program, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('programs')
        .doc(program.id)
        .set(program.toJson());
  }

  Future<void> deleteProgram(Program program, String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('programs')
        .doc(program.id)
        .delete();
  }

  Future<List<Program>> getPrograms(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('programs')
        .orderBy('date', descending: true)
        .get()
        .then((value) => value.docs
        .map((e) => Program.fromJson(e.data()))
        .toList()
        .reversed
        .toList());
  }

  Stream<List<SessionInstance>> getSessionFriends(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .asStream()
        .asyncMap((userDoc) async {
      List<String> friendIds = List<String>.from(userDoc.get('freinds') ?? []);
      List<SessionInstance> sessions = [];
      for (String friendId in friendIds) {
        print(friendId);
        QuerySnapshot sessionsQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .collection('sessions')
            .get();

        for (QueryDocumentSnapshot sessionDoc in sessionsQuery.docs) {
          QuerySnapshot instancesQuery = await FirebaseFirestore.instance
              .collection('users')
              .doc(friendId)
              .collection('sessions')
              .doc(sessionDoc.id)
              .collection('instances')
              .where('completed', isEqualTo: true)
              .get();
          List<SessionInstance> completedInstances = instancesQuery.docs
              .map((doc) => SessionInstance.fromJson({
            'sessionId': sessionDoc.id,
            'sessionInstanceId': doc.id,
            'excercises': sessionDoc.get('excercises'),
            'completed': doc.get('completed'),
            'completedBy': doc.get('completedBy'),
          }))
              .toList();
          if (completedInstances.isNotEmpty) {
            sessions.addAll(completedInstances);
          }
        }
      }
      return sessions;
    });
  }

  Future<Session?> getAllSessionsAndCheckSession(String sessionID) async {
    List<User> users = await getUsers();
    for (User user in users) {
      List<Session> sessions = await getSessions(user.uid);
      for (Session session in sessions) {
        if (session.id == sessionID) {
          return session;
        }
      }
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => User.fromJson(e.data())).toList());
  }

  Future<String?> getUsernameByUid(String uid) async {
    return await _userRef.doc(uid).get().then((value) => value.data()?.name);
  }

  Stream<Program> getProgramStrean(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('programs')
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Program.fromJson(e.data())).toList().first;
    });
  }

}




