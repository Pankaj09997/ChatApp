import 'package:chatapp/Business/Entities/AuthEntities.dart';
import 'package:chatapp/Data/DataSources/AuthApiService.dart';
import 'package:chatapp/Data/models/UserModels.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> signUp(String email, String name, String password, String password2);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<User> login(String email, String password) async {
    final response = await _authApiService.login(email, password);
    final userModel = UserModels.fromJson(response);
    return User(email: userModel.email, name: userModel.name, token: userModel.Token);
  }

  @override
  Future<User> signUp(String email, String name, String password, String password2) async {
    final response = await _authApiService.signUp(email, name, password, password2);
    final userModel = UserModels.fromJson(response);
    return User(email: userModel.email, name: userModel.name, token: userModel.Token);
  }
}

