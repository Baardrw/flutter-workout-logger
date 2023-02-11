class User {
  final String _uid;
  final String? _email;
  final String? _name;
  final List<User> _freinds = [];

  User(this._uid, this._email, this._name);

  void addFreind(User user) {
    _freinds.add(user);
  }

  void remooveFreind(User user) {
    _freinds.remove(user);
  }

  String get uid => _uid;
  String? get email => _email;
  String? get name => _name;

  Map<String, Object?> toJson() {
    return {
      'uid': _uid,
      'email': _email,
      'name': _name,
    };
  }

  User.fromJson(Map<String, Object?> json)
      : _uid = json['uid'] as String,
        _email = json['email'] as String?,
        _name = json['name'] as String;

  @override
  String toString() {
    // TODO: implement toString
    return 'User: $_uid, $_email, $_name';
  }
}
