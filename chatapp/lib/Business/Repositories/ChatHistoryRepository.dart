import 'package:chatapp/Business/Entities/ChatHistoryEntities.dart';
import 'package:chatapp/Data/DataSources/ChatRoomApiService.dart';
import 'package:chatapp/Data/models/ChatHistoryModel.dart';

abstract class ChatHistoryRepositoryBusiness {
  Future<List<ChatHistoryEntities>> getChatHistory(int meId, int frndId);
}

class ChatHistoryRepositoryBusinessImpl
    implements ChatHistoryRepositoryBusiness {
  final ChatRoomApiService chatRoomApiService;

  ChatHistoryRepositoryBusinessImpl({required this.chatRoomApiService});
  Future<List<ChatHistoryEntities>> getChatHistory(int meId, int frndId) async {
    final response = await chatRoomApiService.loadChatHistory(meId, frndId);
    //mapping the data intp the model
    final modelData =
        response.map((json) => ChatHistoryModel.fromJson(json)).toList();
    //mapping the model data into the entities
    final entitiesData = modelData.map((json) => ChatHistoryEntities(
        sender_id: json.sender_id,
        message: json.message,
        timestamp: json.timestamp)).toList();

    return entitiesData;
  }
}
