import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FriendRequestApiService {
  final String baseUrl = "http://127.0.0.1:8000/api";
  String? _token;
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("jwt_token");
  }

  Future<List<dynamic>> friendRequestsList() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unable to Authorize the user");
    }
    final response = await http.get(Uri.parse("$baseUrl/friendrequestlist/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      return errorData;
    }
  }

  Future<Map<String, dynamic>> acceptFriendRequest(int receiver_id) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("Unable to authorize the user");
    }
    final response = await http.post(Uri.parse("$baseUrl/acceptfriendrequest/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode({
          "receiver_id": receiver_id,
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      return errorData;
    }
  }
}
