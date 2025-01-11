class UserSearch {
  final int id;
  final String email;
  final String name;
  final bool is_friend;
  final bool friend_request_sent;

  UserSearch({
    required this.id,
    required this.email,
    required this.name,
    required this.is_friend,
    required this.friend_request_sent,
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      id:json['id'],
        email: json['email'],
        name: json['name'],
        is_friend: json['is_friend'],
        friend_request_sent: json['friend_request_sent']);
  }
}
