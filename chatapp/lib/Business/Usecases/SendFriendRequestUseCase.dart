import 'package:chatapp/Business/Entities/SendFriendRequestEntities.dart';
import 'package:chatapp/Business/Repositories/BusinessSendFriendRequest.dart';
import 'package:chatapp/Data/Respositories/SendFriendRequest.dart';

class SendFriendRequestUseCase {
  final BusinessSendFriendRequestRepositories sendFriendRequestRepositories;

  SendFriendRequestUseCase({required this.sendFriendRequestRepositories});
  Future<SendFriendRequestEntities> sendFriendRequestUseCase(
      int receiverId) async {
    return await sendFriendRequestRepositories.sendFriendRequest(receiverId);
  }
}
