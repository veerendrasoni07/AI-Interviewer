// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String fullname;
  final String phone;

  User({required this.id, required this.email, required this.fullname,required this.phone});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'email': email, 'fullname': fullname,"phone":phone};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? "",
      email: map['email'] ?? "",
      fullname: map['fullname'] ?? "",
      phone: map["phone"] ?? ""
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
