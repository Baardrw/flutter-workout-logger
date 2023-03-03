import 'package:pu_frontend/services/db_service.dart';

import 'group.dart';

/// User is a complex database item, can be retreived via ComplexDbObjectRetriever
class User {
  final String _uid;
  final String? _email;
  final String? _name;

  /// List of userIDs of freinds
  late List<String> _freinds;

  /// List of groupIDs of groups
  late List<String> _groups;

  User(this._uid, this._email, this._name) {
    _freinds = [];
    _groups = [];
  }

  void addFreind(User user) {
    _freinds.add(user.uid);
  }

  void remooveFreind(User user) {
    _freinds.remove(user.uid);
  }

  void joinGroup(Group group) {
    _groups.add(group.id);
  }

  void leaveGroup(Group group) {
    _groups.remove(group.id);
  }

  String get uid => _uid;
  String? get email => _email;
  String? get name => _name;

  Map<String, Object?> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'name': _name,
      'freinds': _freinds,
      'groups': _groups,
    };
  }

  User.fromJson(Map<String, Object?> json)
      : _uid = json['uid'] as String,
        _email = json['email'] as String?,
        _name = json['name'] as String,
        _freinds = (json['freinds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        _groups = (json['groups'] as List<dynamic>?)
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
