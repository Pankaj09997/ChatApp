import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  String? _token;
  String? baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt_token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/login/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['Token']['access'];
      await _saveToken(_token!);
      return data;
    } else {
      throw Exception("Error Data:${response.body}");
    }
  }

  Future<Map<String, dynamic>> signUp(
      String email, String name, String password, String password2) async {
    final response = await http.post(Uri.parse('$baseUrl/signup/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
          'password2': password2
        }));
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['Token'] != null && data['Token']['access'] != null) {
        _token = data['Token']['access'];
        await _saveToken(_token!);
        return data;
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      final errorData = jsonDecode(response.body);
      print("$errorData");
      print("Errors:${errorData['email']}");
      throw Exception('Error: ${errorData['email'] ?? "Unknown error"}');
    }
  }

  Future<bool> isLoggedIn() async {
    await _loadToken();
    return _token != null;
  }
}
