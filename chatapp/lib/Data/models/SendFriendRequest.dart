class SendFriendRequestModel {
  final String message;

  SendFriendRequestModel({required this.message});

  factory SendFriendRequestModel.fromJson(Map<String,dynamic> json) {
    return SendFriendRequestModel(message: json['message']);
  }
}
