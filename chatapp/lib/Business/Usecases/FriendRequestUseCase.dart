import 'package:chatapp/Business/Entities/FriendRequestEntity.dart';
import 'package:chatapp/Business/Repositories/FriendRequestRepository.dart';

class FriendRequestUseCase {
  final FriendRequestListRepositoryBusinessImpl friendRequestListRepositoryBusiness;
  final AcceptFriendRequestRepositoryBusinessImpl acceptFriendRequestRepositoryBusiness;

  FriendRequestUseCase({
    required this.friendRequestListRepositoryBusiness,
    required this.acceptFriendRequestRepositoryBusiness,
  });

  Future<List<FriendRequestListEntity>> friendRequestList() async {
    return friendRequestListRepositoryBusiness.friendRequestList();
  }

  Future<AcceptFriendRequestEntity> acceptFriendRequest(int receiver_id) async {
    return acceptFriendRequestRepositoryBusiness.acceptFriendRequest(receiver_id);
  }
}
