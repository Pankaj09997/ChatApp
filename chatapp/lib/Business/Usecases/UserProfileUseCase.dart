import 'package:chatapp/Business/Entities/UserProfileEntities.dart';
import 'package:chatapp/Business/Repositories/UserProfileRepositories.dart';

class UserProfileUsecase {
  final UserProfileRepositories userProfileRepositories;

  UserProfileUsecase({required this.userProfileRepositories});
  Future<UserProfileEntities> getuserProfile() async {
    return await userProfileRepositories.getUserProfile();
    
  }
}
