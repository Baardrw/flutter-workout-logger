/// Warning: class is not ready to use, only place holder
class Group {
  final String name;
  final List groupMembers;
  final String groupGoal;
  String? lowercaseName;
  String? profilePicture;

  Group(this.name, this.groupMembers, this.groupGoal) {
    lowercaseName = name.toLowerCase();
    profilePicture =
        "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg";
  }

  String get id {
    return name;
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'members': groupMembers,
      'goal': groupGoal,
      'lowercaseName': lowercaseName,
      'profilePicture': profilePicture ??
          "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg"
    };
  }

  Group.fromJson(Map<String, Object?> json)
      : name = json['name'] as String,
        groupMembers = (json['members'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        groupGoal = json['goal'] as String,
        lowercaseName = json['lowercaseName'] as String,
        profilePicture = json['profilePicture'] == null
            ? "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg"
            : json['profilePicture'] as String;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'members': groupMembers,
      'goal': groupGoal,
      'lowercaseName': lowercaseName,
      'profilePicture': profilePicture
    };
  }
}
