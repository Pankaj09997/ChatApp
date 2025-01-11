part of 'user_search_bloc.dart';

@immutable
sealed class UserSearchEvent {}

final class UserSearchType extends UserSearchEvent {
  final String? email;

  UserSearchType({required this.email});
}

final class SearchedUserNavigate extends UserSearchEvent {
  final String? email;

  SearchedUserNavigate({required this.email});
}

final class UserSearchClear extends UserSearchEvent {}

final class UpdateUserRequestSent extends UserSearchEvent {
  final int userId;

  UpdateUserRequestSent({required this.userId});
}
