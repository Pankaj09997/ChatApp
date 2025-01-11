part of 'user_search_bloc.dart';

@immutable
sealed class UserSearchState {}

final class UserSearchInitial extends UserSearchState {}

final class UserSearchSuccess extends UserSearchState {
  final List<Usersearchentities> usersearchentities;

  UserSearchSuccess({required this.usersearchentities});
}

final class UserSearchFailure extends UserSearchState {
  final String message;

  UserSearchFailure({required this.message});
}

final class UserSearchLoading extends UserSearchState {}

final class UserSearchNavigateSuccess extends UserSearchState {
  final String email;

  UserSearchNavigateSuccess({required this.email});
}

final class UserNavigateFailure extends UserSearchState {
  final String errorMessage;

  UserNavigateFailure({required this.errorMessage});
}

