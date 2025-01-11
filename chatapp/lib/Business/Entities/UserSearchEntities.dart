class Usersearchentities {
  final int id;
  final String? email;
  final String ?name;
  final bool is_friend;
  final bool friend_request_sent;

  Usersearchentities(
      {required this.id,
      required this.email,
      required this.name,
      required this.is_friend,
      required this.friend_request_sent});

  Usersearchentities copyWith({
    int? id,
    String? name,
    String? email,
    bool? is_friend,
    bool? friend_request_sent,
  }) {
    return Usersearchentities(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      is_friend: is_friend ?? this.is_friend,
      friend_request_sent: friend_request_sent ?? this.friend_request_sent,
    );
  }
}
