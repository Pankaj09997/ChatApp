part of 'friend_requests_bloc.dart';

@immutable
sealed class FriendRequestsEvent {}

final class FriendRequestList extends FriendRequestsEvent {}

final class AcceptFriendRequest extends FriendRequestsEvent {
  final int receiver_id;

  AcceptFriendRequest({required this.receiver_id});
}
final class NavigateBack extends FriendRequestsEvent{}