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
}
