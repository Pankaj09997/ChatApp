part of 'send_friend_request_bloc.dart';

@immutable
sealed class SendFriendRequestState {}

final class SendFriendRequestInitial extends SendFriendRequestState {}

final class FriendRequestSentSuccess extends SendFriendRequestState {
  final SendFriendRequestEntities sendFriendRequestEntities;

  FriendRequestSentSuccess({required this.sendFriendRequestEntities});
}

final class SendFriendRequestLoading extends SendFriendRequestState {}

final class SendFriendRequestError extends SendFriendRequestState {
  final String message;

  SendFriendRequestError({required this.message});
}
