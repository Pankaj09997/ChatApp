part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});
}

class NavigateToSignUpState extends AuthState{}
class NavigateToLoginState extends AuthState{}
class NavigateToProfileState extends AuthState{}

