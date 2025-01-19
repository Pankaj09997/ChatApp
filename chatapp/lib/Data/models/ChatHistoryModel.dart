class ChatHistoryModel {
  final int sender_id;
  final String message;
  final String timestamp;

  ChatHistoryModel(
      {required this.sender_id,
      required this.message,
      required this.timestamp});

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
        sender_id: json['sender_id'],
        message: json['message'],
        timestamp: json['timestamp']);
  }
  Map<String, dynamic> toJson() {
    return {'sender_id': sender_id, 'message': message, 'timestamp': timestamp};
  }
}
