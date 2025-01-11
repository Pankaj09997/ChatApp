import 'package:chatapp/Business/Entities/FriendListEntities.dart';
import 'package:chatapp/Business/Repositories/FriendListRepoBusiness.dart';

class FriendListUseCase {
  final FriendListRepoBusiness friendListRepoBusiness;

  FriendListUseCase({required this.friendListRepoBusiness});
  Future<List<FriendListEntities>> getFriendList() async {
    return await friendListRepoBusiness.getFriendList();
  }
}
