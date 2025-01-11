part of 'send_friend_request_bloc.dart';

@immutable
sealed class SendFriendRequestEvent {}

final class SendFriendRequest extends SendFriendRequestEvent {
  final int receiverId;

  SendFriendRequest({required this.receiverId});
}
