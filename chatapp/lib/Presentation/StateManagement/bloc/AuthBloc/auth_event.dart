part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

final class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;
  final String password2;

  AuthSignUpEvent({required this.email, required this.name, required this.password, required this.password2});
}
 class NavigateToSignUp extends AuthEvent{

 }
 class NavigateToSignIn extends AuthEvent{

 }
 
 class NavigateToProfilePicture extends AuthEvent{
  
 }