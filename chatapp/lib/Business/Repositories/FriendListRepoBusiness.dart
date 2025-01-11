import 'package:chatapp/Business/Entities/FriendListEntities.dart';
import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/FriendList.dart';

abstract class FriendListRepoBusiness {
  Future<List<FriendListEntities>> getFriendList();
}

class FriendListRepoBusinessImpl implements FriendListRepoBusiness {
  final HomePageApiService homePageApiService;

  FriendListRepoBusinessImpl({required this.homePageApiService});
  Future<List<FriendListEntities>> getFriendList() async {
    final response = await homePageApiService.seeAllFriends();
    //converting the data into the models
    final modelData =
        response.map((json) => FriendListModel.fromJson(json)).toList();
    //now mappping the model data into the entities
    final userEntities = modelData
        .map((json) =>
            FriendListEntities(email: json.email, name: json.name, id: json.id))
        .toList();
    return userEntities;
  }
}
