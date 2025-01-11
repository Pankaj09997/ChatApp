import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/UserSearch.dart';

class UserSearchRepositories {
  final HomePageApiService homePageApiService = HomePageApiService();
  Future<List<UserSearch>> userSearch(String query) async {
    List<dynamic> response =
        await homePageApiService.userSearch(query);
    return response.map((json) => UserSearch.fromJson(json)).toList();
  }
}
