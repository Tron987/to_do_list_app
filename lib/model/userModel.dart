class User {
  String fullName;
  String email;
  String password;
  String photoUrl;

  User({required this.fullName, required this.email, required this.password, required this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'photoUrl' : photoUrl
    };
  }
}
