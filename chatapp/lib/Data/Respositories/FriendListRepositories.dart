import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/FriendList.dart';

class FriendListRepositories {
  final HomePageApiService homePageApiService;

  FriendListRepositories({required this.homePageApiService});
  Future<List<FriendListModel>> getFriendList() async {
    //getting the response from the api
    final response = await homePageApiService.seeAllFriends();
    //converting the response into the dart objects
    return response.map<FriendListModel>((json) => FriendListModel.fromJson(json)).toList();
  }
}

