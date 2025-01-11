import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ProfilePictureService {
  String? _token;
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token');
  }
// Make sure this is imported

Future<Map<String, dynamic>> getProfilePicture() async {
  await _loadToken();
  if (_token == null) {
    throw Exception("User is not authorized");
  }
  
  final response = await http.get(
    Uri.parse("$baseUrl/profilepicture/"),
    headers: <String, String>{'Authorization': 'Bearer $_token'},
  );
  
  if (response.statusCode == 200) {
    // Parse the response body into a Map
    var data = jsonDecode(response.body);
    
    // Now you can access the 'image' field
    print("${data['image']}");
    
    return {'status': 'success', 'data': data};
  } else {
    return {
      'status': 'failed',
      'message': jsonDecode(response.body)['detail'] ?? 'Unknown error'
    };
  }
}


  Future<Map<String, dynamic>> deleteProfilePicture() async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authorized");
    }
    final response = await http.delete(
      Uri.parse("$baseUrl/profilepicture/"),
      headers: <String, String>{'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 204) {
      return {
        'status': 'success',
        'message': 'Profile picture deleted successfully'
      };
    } else {
      return {
        'status': 'failed',
        'message': jsonDecode(response.body)['detail'] ?? 'Unknown error'
      };
    }
  }

  Future<Map<String, dynamic>> uploadProfilePicture(File? image) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authorized");
    }

    final String url = "$baseUrl/profilepicture/";
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Debug token
    print("Token: $_token");

    // Add authorization header
    request.headers.addAll({'Authorization': 'Bearer $_token'});

    // Add the file if it exists
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromBytes(
          'image', // Field name expected by the API
          await image.readAsBytes(),
          filename: image.path.split('/').last,
        ),
      );
    } else {
      throw Exception("No file provided for upload.");
    }

    // Debug request
    print("Request: ${request.fields}");

    // Send the request
    final response = await request.send();

    // Handle the response
    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return {'status': 'success', 'data': jsonDecode(responseBody)};
    } else {
      final responseBody = await response.stream.bytesToString();
      print("Response: $responseBody");
      return {
        'status': 'failed',
        'message': jsonDecode(responseBody)['detail'] ?? 'Unknown error',
        'response': jsonDecode(responseBody),
      };
    }
  }

  Future<Map<String, dynamic>> updateProfilePicture(File? image) async {
    await _loadToken();
    if (_token == null) {
      throw Exception("User is not authorized");
    }

    final String url = "$baseUrl/profilepicture/";
    final request = http.MultipartRequest('PATCH', Uri.parse(url));

    // Add authorization header
    request.headers.addAll({'Authorization': 'Bearer $_token'});

    // Add the file if it exists
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromBytes(
          'image', // Field name expected by the API
          await image.readAsBytes(),
          filename: image.path.split('/').last,
          contentType: MediaType('image', 'jpeg'), // Adjust for your file type
        ),
      );
    } else {
      throw Exception("No file provided for upload.");
    }

    // Send the request
    final response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return {'status': 'success', 'data': jsonDecode(responseBody)};
    } else {
      final responseBody = await response.stream.bytesToString();
      return {
        'status': 'failed',
        'message': jsonDecode(responseBody)['detail'] ?? 'Unknown error',
        'response': jsonDecode(responseBody),
      };
    }
  }
}
