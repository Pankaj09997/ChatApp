import 'package:chatapp/Business/Entities/SendFriendRequestEntities.dart';
import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/SendFriendRequest.dart';

abstract class BusinessSendFriendRequestRepositories {
  Future<SendFriendRequestEntities> sendFriendRequest(int receiverId);
}

class BusinessSendFriendRequestRepositoriesImpl
    implements BusinessSendFriendRequestRepositories {
  final HomePageApiService homePageApiService;

  BusinessSendFriendRequestRepositoriesImpl({required this.homePageApiService});
  Future<SendFriendRequestEntities> sendFriendRequest(int receiverId) async {
    final response = await homePageApiService.sendFriendRequest(receiverId);
    final model = await SendFriendRequestModel.fromJson(response);
    return SendFriendRequestEntities(message: model.message);
  }
}
