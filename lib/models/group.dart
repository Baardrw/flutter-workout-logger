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
        "https://farm5.static.flickr.com/4007/4177211228_9fc2029702_z.jpg";
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
          "https://farm5.static.flickr.com/4007/4177211228_9fc2029702_z.jpg"
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
            ? "https://farm5.static.flickr.com/4007/4177211228_9fc2029702_z.jpg"
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
