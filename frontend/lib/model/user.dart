// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class User {
  final String id;
  final String email;
  final String fullname;
  final String phone;
  final int credits;
  final bool isPremium;

  User({required this.id, required this.email, required this.fullname, required this.phone, required this.credits, required this.isPremium});

  User copyWith({
    String? id,
    String? email,
    String? fullname,
    String? phone,
    int? credits,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      credits: credits ?? this.credits,
      isPremium: isPremium ?? this.isPremium,
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'fullname': fullname,
      'phone': phone,
      'credits': credits,
      'isPremium': isPremium,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? "",
      email: map['email'] ?? "",
      fullname: map['fullname'] ?? "",
      phone: map["phone"] ?? "",
      credits: map['credits'] ?? 0,
      isPremium: map["isPremium"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
