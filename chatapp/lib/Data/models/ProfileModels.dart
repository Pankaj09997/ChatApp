class ProfilePicture {
  final String? status;
  final Map<String, dynamic>? data;
  final String? message;
  final Map<String, dynamic>? response;

  ProfilePicture(
      {required this.status,
      required this.data,
      required this.message,
      required this.response});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
        status: json['status'],
        data: json['data'],
        message: json['message'],
        response: json['response']);
  }
}
