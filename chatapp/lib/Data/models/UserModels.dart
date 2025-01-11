import 'package:flutter/foundation.dart';

class UserModels {
  final String email;
  final String name;
  final String Token;
// converts the incoming data to the dart objects
  UserModels({required this.email, required this.name, required this.Token});
  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      Token: json['Token']?['access'] ?? "",
    );
  }
  //converts the outgoing data to the respective type
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'Token': {'access': Token},
    };
  }
}
