part of 'friend_requests_bloc.dart';

@immutable
sealed class FriendRequestsState {}

final class FriendRequestsInitial extends FriendRequestsState {}

final class FriendRequestListLoading extends FriendRequestsState {}

final class FriendRequestListError extends FriendRequestsState {
  final String message;

  FriendRequestListError({required this.message});
}

final class FriendRequestListSuccess extends FriendRequestsState {
  final List<FriendRequestListEntity> friendRequestList;

  FriendRequestListSuccess({required this.friendRequestList});
}

final class AcceptFriendRequestLoading extends FriendRequestsState {}

final class AcceptFriendRequestFailure extends FriendRequestsState {
  final String message;

  AcceptFriendRequestFailure({required this.message});
}

final class AcceptFriendRequestSuccess extends FriendRequestsState {
  final AcceptFriendRequestEntity acceptFriendRequestEntity;

  AcceptFriendRequestSuccess({required this.acceptFriendRequestEntity});
}
final class NavigateBackState extends FriendRequestsState{}
