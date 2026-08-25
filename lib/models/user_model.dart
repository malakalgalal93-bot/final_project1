class UserModel {
  int? id;
  String username;
  String password;
  String? image;
  String role;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    this.image,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      image: map['image'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'image': image,
      'role': role,
    };
  }
}