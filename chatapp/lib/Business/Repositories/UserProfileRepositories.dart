import 'package:chatapp/Business/Entities/UserProfileEntities.dart';
import 'package:chatapp/Data/DataSources/UserProfileApiService.dart';
import 'package:chatapp/Data/models/UserProfileModel.dart';

abstract class UserProfileRepositories {
  Future<UserProfileEntities> getUserProfile();
}

class UserProfileRepositoriesImpl implements UserProfileRepositories {
  final UserProfileApiService userProfileApiService;

  UserProfileRepositoriesImpl({required this.userProfileApiService});
  Future<UserProfileEntities> getUserProfile() async {
    //we get the data in the json from the api
    final response = await userProfileApiService.getUserProfile();
    print(response);
    //converting data into the models
    final userModel = UserProfileModel.fromJson(response);
    //mapping the data into the entities
    return UserProfileEntities(
        id: userModel.id!,
        email: userModel.email!,
        name: userModel.name!,
        is_active: userModel.is_active!,
        last_login: userModel.last_login!);
  }
}
