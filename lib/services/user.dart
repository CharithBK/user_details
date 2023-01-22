class User {
  String _id = '';
  String _username = '';

  User(id, username) {
    this._id = id.toString();
    this._username = username.toString();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['username']);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }
}
