import 'dart:convert';

import 'package:chatapp/Business/Entities/UserSearchEntities.dart';
import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/UserModels.dart';
import 'package:chatapp/Data/models/UserSearch.dart';

abstract class UserSearchRepositories {
  Future<List<Usersearchentities>> userSearch(String query);
}

class UsersearchrepositoriesImpl implements UserSearchRepositories {
  final HomePageApiService homePageApiService;

  UsersearchrepositoriesImpl({required this.homePageApiService});
  Future<List<Usersearchentities>> userSearch(String query) async {
    //Fetching the data from the api service this would fecth the data in the json
    List<dynamic> response =
        await homePageApiService.userSearch(query);
    //converting the fetched data into the model
    final userSearchModel =
        response.map((json) => UserSearch.fromJson(json)).toList();
    //mapping the usermodel into the entities since the usermodel is in the list
    final userSearchEnitity = userSearchModel.map((json) =>
       Usersearchentities(
        id: json.id,
          email: json.email,
          name: json.name,
          is_friend: json.is_friend,
          friend_request_sent: json.friend_request_sent)
    ).toList();
    return userSearchEnitity;
  }
}
