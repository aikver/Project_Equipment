import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  final User user;
  final String accessToken;
  final String refreshToken;

  Usermodel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

class User {
  final String id;
  final String userName;
  final String firstname;
  final String lastname;
  final String phone;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.userName,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"], // Backend uses "_id" as the ID field
        userName: json["user_name"], // Backend uses "user_name"
        firstname: json["firstname"], 
        lastname: json["lastname"],
        phone: json["phone"] ?? "", // Backend may not send "phone" (optional)
        role: json["role"], // Backend sends "role"
        createdAt: DateTime.parse(json["createdAt"]), // Convert timestamp
        updatedAt: DateTime.parse(json["updatedAt"]), // Convert timestamp
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
