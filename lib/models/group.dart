/// Warning: class is not ready to use, only place holder
class Group {
  final String name;
  final List groupMembers;
  final String groupGoal;

  Group(
      this.name,
      this.groupMembers,
      this.groupGoal,
      );

  String get id {
    return name;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': groupMembers,
      'goal': groupGoal,
    };
  }

  //Users.contains method which returns the group
  bool contains(String uid) {
    return groupMembers.contains(uid);
  }


  Group.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        groupMembers = map['members'],
        groupGoal = map['goal'];

  Group.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        groupMembers = json['members'],
        groupGoal = json['goal'];
}
