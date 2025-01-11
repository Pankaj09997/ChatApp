import 'package:chatapp/Business/Entities/UserSearchEntities.dart';
import 'package:chatapp/Business/Repositories/UserSearchRepositories.dart';

class UserSearchUseCase {
  final UserSearchRepositories userSearchRepositories;

  UserSearchUseCase({required this.userSearchRepositories});

  Future<List<Usersearchentities>> userSearchUseCase(String query) async {
    return await userSearchRepositories.userSearch(query);
  }
}
