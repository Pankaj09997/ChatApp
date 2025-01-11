class FriendListModel {
  final String ? email;
  final String ? name;
  final int ? id;

  FriendListModel({required this.email, required this.name, required this.id});

  //for receiving the data from the api converts the json data into the dart objects
  factory FriendListModel.fromJson(Map<String,dynamic>json) {
    return FriendListModel(email: json['email'], name: json['name'], id: json['id']);
  }
}
