import 'package:chatapp/Business/Entities/AuthEntities.dart';
import 'package:chatapp/Business/Repositories/AuthRepositories.dart';


class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<User> login(String email, String password) async {
    return await authRepository.login(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  Future<User> signUp(String email, String name, String password, String password2) async {
    return await authRepository.signUp(email, name, password, password2);
  }
}
