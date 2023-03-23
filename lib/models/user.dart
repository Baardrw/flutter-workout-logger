import 'package:flutter/rendering.dart';
import 'package:pu_frontend/services/db_service.dart';

import 'group.dart';

/// User is a complex database item, can be retreived via ComplexDbObjectRetriever
class User {
  final String _uid;
  final String? _email;
  final String? _name;
  String? _lowercaseName;
  String? _profilePicture;

  late List<String> _pictures;

  /// List of userIDs of freinds
  late List<String> _freinds;

  /// List of groupIDs of groups stored as
  late List<Membership> _groups;

  late List<String> _freindRequests;

  User(this._uid, this._email, this._name) {
    if (name == null) {
      _lowercaseName = "";
    } else {
      _lowercaseName = _name!.toLowerCase();
    }
    _freinds = [];
    _groups = [];
    _freindRequests = [];
    _profilePicture =
        "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg";
    _pictures = [];
  }

  void addFreind(User user) {
    if (!_freinds.contains(user.uid)) _freinds.add(user.uid);
  }

  void removeFreind(String uid) {
    if (_freinds.contains(uid)) _freinds.remove(uid);
  }

  void addFreindRequest(String uid) {
    if (!_freindRequests.contains(uid)) _freindRequests.add(uid);
  }

  void removeFreindRequest(String uid) {
    if (_freindRequests.contains(uid)) _freindRequests.remove(uid);
  }

  void joinGroup(Group group, bool isAdmin) {
    Membership member = Membership(group.name, isAdmin);
    Membership memberOp = Membership(group.name, !isAdmin);
    if (!_groups.contains(member) || !_groups.contains(memberOp))
      _groups.add(member);
  }

  void leaveGroup(Group group) {
    Membership member = Membership(group.name, false);
    if (_groups.contains(member)) _groups.remove(member);
    member = Membership(group.name, true);
    if (_groups.contains(member)) _groups.remove(member);
  }

  String get uid => _uid;
  String? get email => _email;
  String? get name => _name;
  List<String> get freinds => _freinds;
  List<dynamic> get groups => _groups;
  String? get profilePicture => _profilePicture;
  List<String> get picturesUrls => _pictures;
  List<String> get freindRequests => _freindRequests;
  set profilePicture(String? url) => _profilePicture = url;

  Map<String, Object?> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'name': _name,
      'freinds': _freinds,
      'freindRequests': _freindRequests,
      'groups': _groups.map((e) => e.toJson()).toList(),
      'lowercaseName': _lowercaseName,
      'profilePicture': _profilePicture ??
          "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg",
      'pictures': _pictures,
    };
  }

  User.fromJson(Map<String, Object?> json)
      : _uid = json['uid'] as String,
        _email = json['email'] as String?,
        _name = json['name'] as String,
        _lowercaseName = json['lowercaseName'] == null
            ? json['name'].toString().toLowerCase()
            : json['lowercaseName'] as String,
        _freinds = (json['freinds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        _freindRequests = (json['freindRequests'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        _groups = (json['groups'] as List<dynamic>?)
                ?.map((e) => Membership.fromJson(e as Map<String, Object?>))
                .toList() ??
            [],
        _profilePicture = json['profilePicture'] as String,
        _pictures = (json['pictures'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [];

  @override
  String toString() {
    return 'User: $_uid, $_email, $_name';
  }

  Future<List<User?>> getFreinds() async {
    DatabaseService db = DatabaseService();

    List<User?> freinds = [];
    for (String freind in _freinds) {
      freinds.add(await db.getUser(freind));
    }

    return freinds;
  }

  void addProfilePicture(String url) {
    _profilePicture = url;
  }

  void addPicture(String url) {
    _pictures.add(url);
  }

  void removePicture(String url) {
    _pictures.remove(url);
  }
}

class Membership implements Comparable<Membership> {
  final String groupName;
  final bool isAdmin;

  Membership(this.groupName, this.isAdmin);

  @override
  String toString() {
    return 'Membership: $groupName, $isAdmin';
  }

  Membership.fromJson(Map<String, Object?> json)
      : groupName = json['groupName'] as String,
        isAdmin = json['isAdmin'] as bool;

  Map<String, Object?> toJson() {
    return {
      'groupName': groupName,
      'isAdmin': isAdmin,
    };
  }

  @override
  int compareTo(Membership other) {
    // TODO: implement compareTo
    return groupName.compareTo(other.groupName);
  }
}
