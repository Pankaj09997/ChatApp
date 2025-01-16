part of 'friend_list_bloc.dart';

@immutable
sealed class FriendListState {}

final class FriendListInitial extends FriendListState {}

final class FriendListLoading extends FriendListState {}

final class FrinedListError extends FriendListState {
  final String message;

  FrinedListError({required this.message});
}

final class FriendListNavigateState extends FriendListState {
  final int id;
  final String name;

  FriendListNavigateState(this.name, {required this.id});
}

class FriendListSucessState extends FriendListState {
  final ProfilePictureEntities profilePictureEntities;
  final List<FriendListEntities> friendListEntities;

  FriendListSucessState({
    required this.profilePictureEntities,
    required this.friendListEntities,
  });
}

