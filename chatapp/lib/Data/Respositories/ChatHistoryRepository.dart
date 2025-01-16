import 'package:chatapp/Data/DataSources/ChatRoomApiService.dart';
import 'package:chatapp/Data/models/ChatHistoryModel.dart';

class ChatHistoryRepository {
  final ChatRoomApiService chatRoomApiService;

  ChatHistoryRepository({required this.chatRoomApiService});

  Future<List<ChatHistoryModel>> getChatHistory(int meId, int frndId) async {
    final response = await chatRoomApiService.loadChatHistory(meId, frndId);
    return response.map((json)=>ChatHistoryModel.fromJson(json)).toList();
  }
}
