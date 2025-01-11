import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/models/SendFriendRequest.dart';

class SendFriendRequestRepositories {
  final HomePageApiService homePageApiService;
  SendFriendRequestRepositories({required this.homePageApiService});

  Future<SendFriendRequestModel> sendFriendRequest(int receiverid) async {
    final response = await homePageApiService.sendFriendRequest(receiverid);
    return SendFriendRequestModel.fromJson(response);
  }
}
