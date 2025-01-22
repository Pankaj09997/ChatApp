import 'package:chatapp/Business/Entities/FriendRequestEntity.dart';
import 'package:chatapp/Data/DataSources/FriendRequestApiService.dart';
import 'package:chatapp/Data/models/FriendRequestModel.dart';

abstract class FriendRequestRepositoryBusiness {
  Future<AcceptFriendRequestEntity> acceptFriendRequest(int receiver_id);
  Future<List<FriendRequestListEntity>> friendRequestList();
}

class AcceptFriendRequestRepositoryBusinessImpl implements FriendRequestRepositoryBusiness {
  final FriendRequestApiService friendRequestApiService;

  AcceptFriendRequestRepositoryBusinessImpl({required this.friendRequestApiService});
 
  Future<AcceptFriendRequestEntity> acceptFriendRequest(int receiver_id) async {
    try {
      final response = await friendRequestApiService.acceptFriendRequest(receiver_id);
      final modelData = await AcceptFriendRequestModel.fromJson(response);
      return AcceptFriendRequestEntity(message: modelData.message);
    } catch (error) {
      throw Exception('Error accepting friend request: $error');
    }
  }

  Future<List<FriendRequestListEntity>> friendRequestList() async {
    throw UnimplementedError();
  }
}

class FriendRequestListRepositoryBusinessImpl implements FriendRequestRepositoryBusiness {
  final FriendRequestApiService friendRequestApiService;

  FriendRequestListRepositoryBusinessImpl({required this.friendRequestApiService});

  Future<AcceptFriendRequestEntity> acceptFriendRequest(int receiver_id)async {
    throw UnimplementedError();
  }

  Future<List<FriendRequestListEntity>> friendRequestList() async {
    try {
      final response = await friendRequestApiService.friendRequestsList();
      final modelData = response.map((json) => FriendRequestListModel.fromJson(json)).toList();
      return modelData
          .map((json) => FriendRequestListEntity(id: json.id, name: json.name, email: json.email))
          .toList();
    } catch (error) {
      throw Exception('Error fetching friend request list: $error');
    }
  }
}
