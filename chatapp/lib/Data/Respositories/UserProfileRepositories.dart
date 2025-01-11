import 'package:chatapp/Data/DataSources/UserProfileApiService.dart';
import 'package:chatapp/Data/models/UserProfileModel.dart';

class UserProfileRepositories {
  final UserProfileApiService userProfileApiService;

  UserProfileRepositories({required this.userProfileApiService});
  Future<UserProfileModel> getUserProfile() async {
    final response = await userProfileApiService.getUserProfile();
    return UserProfileModel.fromJson(response);
  }
}
