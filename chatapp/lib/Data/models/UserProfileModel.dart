class UserProfileModel {
  final int? id;
  final String? email;
  final String?name;
  final bool? is_active;
  final DateTime? last_login;

  UserProfileModel({required this.id, required this.email, required this.name, required this.is_active, required this.last_login});

  //when receiving the data i need to convert the data that is in json objects into the dart objects
   factory UserProfileModel.fromJson(Map<String,dynamic> json){
    return UserProfileModel(id: json['id']??"", email: json['email']??"", name: json['name']??"", is_active: json['is_active']??"",     last_login: json['last_login'] != null
        ? DateTime.parse(json['last_login']) // Convert string to DateTime
        : null);

   }
   //sending the data to the server which is done by the api service via http.post
   Map<String,dynamic> toJson(){
     return {
      "id":id,
      'email':email,
      'name':name,
       'is_active':is_active,
       'last_login':last_login
     };
   }
}
