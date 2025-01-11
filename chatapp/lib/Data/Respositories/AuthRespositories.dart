import 'package:chatapp/Data/DataSources/AuthApiService.dart';
import 'package:chatapp/Data/models/UserModels.dart';

class AuthRespositories {
  final AuthApiService authApiService = AuthApiService();
  Future<UserModels> SignUpRespositories(
      String email, String name, String password, String password2) async {
    try {
      final response =
          await authApiService.signUp(email, name, password, password2);
      return UserModels.fromJson(response);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  Future<UserModels> Login(String email, String password) async {
    try {
      final response = await authApiService.login(email, password);
      return UserModels.fromJson(response);
    } catch (e) {
      throw Exception("Login Failed $e");
    }
  }
}
