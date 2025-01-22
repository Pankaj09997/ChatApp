import 'package:chatapp/Data/DataSources/FriendRequestApiService.dart';
import 'package:chatapp/Data/models/FriendRequestModel.dart';

class FriendRequestListRepository {
  final FriendRequestApiService friendRequestApiService;

  FriendRequestListRepository({required this.friendRequestApiService});

  Future<List<FriendRequestListModel>> friendRequestListRepository() async {
    final resposne = await friendRequestApiService.friendRequestsList();
    return resposne
        .map((json) => FriendRequestListModel.fromJson(json))
        .toList();
  }

  Future<AcceptFriendRequestModel> acceptFriendRequestRepository(
      int receiver_id) async {
    final resposne =
        await friendRequestApiService.acceptFriendRequest(receiver_id);
    return AcceptFriendRequestModel.fromJson(resposne);
  }
}
