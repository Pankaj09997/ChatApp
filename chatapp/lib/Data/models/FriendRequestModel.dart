class AcceptFriendRequestModel {
  final String message;

  AcceptFriendRequestModel({required this.message});

  factory AcceptFriendRequestModel.fromJson(Map<String, dynamic> json) {
    return AcceptFriendRequestModel(message: json['message']);
  }
  Map<String, dynamic> toJson() {
    return {"message": message};
  }
}

class FriendRequestListModel {
  final int id;
  final String email;
  final String name;

  FriendRequestListModel(
      {required this.id, required this.email, required this.name});

  factory FriendRequestListModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestListModel(
        id: json['id'], email: json['email'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
    };
  }
}
