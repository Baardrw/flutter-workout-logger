import 'package:flutter/cupertino.dart';
import 'package:pu_frontend/services/db_service.dart';

/// Warning: class is not ready to use, only place holder
class Group {
  final String _name;
  final List<String> _groupMembers;
  final String _groupGoal;
  final List<String> _administrators;

  Group(
    this._name, 
    this._groupGoal,
    this._groupMembers,
    this._administrators
  );


  String get id {
    return _name;
  }
  List<String> get groupmembers => _groupMembers;
  String? get groupGoal => _groupGoal;
  List<String> get administrators => _administrators;


  Map<String, Object> toJson() {
    return {
      'name': _name,
      'members': _groupMembers,
      'goal': _groupGoal,
      'administrators': _administrators
    };
  }

  Group.fromJson(Map<String, Object?> json)
    : _name = json['id'] as String,
    _groupMembers = (json['groupmembers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    _groupGoal = json['goal'] as String,
    _administrators = (json['administrators'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [];

  @override
  String toString() {
    return 'Group:  $_name, $_groupGoal' ;
  }

  Future<List<Group?>> getMembers() async {
    DatabaseService db = DatabaseService();

    List<Group?> groupMembers = [];
    for (String member in _groupMembers) {
      groupMembers.add(await db.getMember(member));
    }
    
    return groupMembers;
  }


}
