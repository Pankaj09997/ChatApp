import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileApiService {
  String? _token;
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unable to authorize the user");
    }
    final response = await http.get(
      Uri.parse("$baseUrl/profile/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = await jsonDecode(response.body);
      return errorData;
    }
  }
}
