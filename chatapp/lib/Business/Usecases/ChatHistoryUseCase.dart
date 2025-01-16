import 'package:chatapp/Business/Entities/ChatHistoryEntities.dart';
import 'package:chatapp/Business/Repositories/ChatHistoryRepository.dart';
import 'package:chatapp/Data/models/ChatHistoryModel.dart';

class ChatHistoryUseCase {
  final ChatHistoryRepositoryBusiness chatHistoryRepositoryBusiness;

  ChatHistoryUseCase({required this.chatHistoryRepositoryBusiness});
  Future<List<ChatHistoryEntities>> getChatHistory(int meId, int frndId) async {
    return await chatHistoryRepositoryBusiness.getChatHistory(meId, frndId);
  }
}
