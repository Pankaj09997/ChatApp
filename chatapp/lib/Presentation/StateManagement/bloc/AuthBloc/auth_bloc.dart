import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/AuthEntities.dart';
import 'package:chatapp/Business/Repositories/AuthRepositories.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginEvent>(_authLoginEvent);
    on<AuthSignUpEvent>(_authSignUpEvent);
    on<NavigateToSignUp>(_navigateToSignUp);
    on<NavigateToSignIn>(_navigateToSignIn);
    on<NavigateToProfilePicture>(navigateToProfileEvent);
  }

  // Handler for login event
  Future<void> _authLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(event.email, event.password);
      emit(AuthSuccess(user: response));
    } catch (e) {
      print("Error :$e");
      emit(AuthError(message: "Login failed. Please check your credentials."));
    }
  }

  // Handler for sign-up event
  Future<void> _authSignUpEvent(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signUp(
          event.email, event.name, event.password, event.password2);
      emit(AuthSuccess(user: response));
      await Future.delayed(Duration(milliseconds: 100));
      emit(NavigateToLoginState()); // Navigate to login page after signup
    } catch (error) {
      print("Error:$error");
      emit(AuthError(message: "$error"));
    }
  }

  // Handler to navigate to sign-up page
  void _navigateToSignUp(NavigateToSignUp event, Emitter<AuthState> emit) {
    emit(NavigateToSignUpState());
  }

  // Handler to navigate to sign-in page
  void _navigateToSignIn(NavigateToSignIn event, Emitter<AuthState> emit) {
    emit(NavigateToLoginState());
  }

  void navigateToProfileEvent(
      NavigateToProfilePicture event, Emitter<AuthState> emit) {
    emit(NavigateToProfileState());
  }
}
