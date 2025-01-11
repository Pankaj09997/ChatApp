import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePageApiService {
  String? _token;
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }

  Future<List<dynamic>> userSearch(String query) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unauthorized access");
    }
    final response =
        await http.get(Uri.parse("$baseUrl/user/search/?q=$query"), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      print("$errorData");
      return errorData;
    }
  }

  Future<Map<String, dynamic>> sendFriendRequest(int receiverId) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unable to authorize the user");
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addfriend/"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({"receiver_id": receiverId}),
      );

      if (response.statusCode == 201) {
        // Successful response
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ??
            errorData['message'] ??
            'Unknown error occurred.';
        throw Exception("Error: $errorMessage");
      }
    } catch (e) {
      print("Error in sendFriendRequest: $e");
      throw Exception("Error: Unable to process your request. $e");
    }
  }

  Future<List<dynamic>> seeAllFriends() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unauthorized User");
    }
    final response = await http.get(Uri.parse("$baseUrl/viewfriendlist/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("$data");
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      return errorData;
    }
  }
}
