part of 'friend_list_bloc.dart';

@immutable
sealed class FriendListEvent {}

final class NavigateToChatRoomEvent extends FriendListEvent {
  final int id;
  final String name;
  NavigateToChatRoomEvent( {required this.id,required this.name});
}

final class ShowFriendList extends FriendListEvent {}
