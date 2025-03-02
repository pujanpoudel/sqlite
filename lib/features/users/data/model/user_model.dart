class UserBaseModel {
  List<User> users;

  UserBaseModel({required this.users});

  factory UserBaseModel.fromJson(Map<String, dynamic> json) {
    return UserBaseModel(
        users: (json['users'] as List<dynamic>)
            .map((model) => User.fromJson(model))
            .toList());
  }
}

class User {
  int id;
  String name;
  String gender;
  String age;
  String email;

  User(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['firstName'] as String,
      age: json['age'].toString(),
      gender: json['gender'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
    };
  }
}
