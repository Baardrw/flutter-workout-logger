import 'package:pu_frontend/services/db_service.dart';

import 'group.dart';

/// User is a complex database item, can be retreived via ComplexDbObjectRetriever
class User {
  final String _uid;
  final String? _email;
  final String? _name;
  String? _lowercaseName;
  String? _profilePicture;

  /// List of userIDs of freinds
  late List<String> _freinds;

  /// List of groupIDs of groups stored as [groupID, groupName]
  late List<dynamic> _groups;

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

  void joinGroup(Group group) {
    if (!_groups.contains(group.id)) _groups.add(group.id);
  }

  void leaveGroup(Group group) {
    if (_groups.contains(group.id)) _groups.remove(group.id);
  }

  String get uid => _uid;
  String? get email => _email;
  String? get name => _name;
  String? get profilePicture => _profilePicture;
  List<String> get freinds => _freinds;
  List<dynamic> get groups => _groups;
  List<String> get freindRequests => _freindRequests;
  set profilePicture(String? url) => _profilePicture = url;

  Map<String, Object?> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'name': _name,
      'freinds': _freinds,
      'freindRequests': _freindRequests,
      'groups': _groups,
      'lowercaseName': _lowercaseName,
      'profilePicture': _profilePicture ??
          "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg",
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
                ?.map((e) => e as String)
                .toList() ??
            [],
        _profilePicture = json['profilePicture'] as String?;

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

  // TODO : add user functionality to get groups

  // Future<List<Group?>> getGroups() async {
  //   DatabaseService db = DatabaseService();

  //   List<Group?> groups = [];
  //   for (String group in _groups) {
  //     groups.add(await db.getGroup(group));
  //   }

  //   return groups;
  // }
}
