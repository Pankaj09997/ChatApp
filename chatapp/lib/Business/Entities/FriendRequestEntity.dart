class AcceptFriendRequestEntity {
  final String message;

  AcceptFriendRequestEntity({required this.message});
}

class FriendRequestListEntity {
  final int id;
  final String name;
  final String email;

  FriendRequestListEntity({required this.id, required this.name, required this.email});
}
