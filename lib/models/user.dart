class User {
  final String uid;
  final String? email;
  final String? name;

  User(this.uid, this.email, this.name);

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  User.fromJson(Map<String, Object?> json)
      : uid = json['uid'] as String,
        email = json['email'] as String?,
        name = json['name'] as String;
}

void main(List<String> args) {
  User u = User('uid', 'email', 'name');
}
