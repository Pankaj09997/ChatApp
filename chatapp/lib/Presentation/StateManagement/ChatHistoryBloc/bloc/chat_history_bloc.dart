import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/ChatHistoryEntities.dart';
import 'package:chatapp/Business/Usecases/ChatHistoryUseCase.dart';
import 'package:meta/meta.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final ChatHistoryUseCase chatHistoryUseCase;
  ChatHistoryBloc(this.chatHistoryUseCase) : super(ChatHistoryInitial()) {
    on<ChatHistoryLoad>(chatHistoryLoad);
  }
  Future<void> chatHistoryLoad(
      ChatHistoryLoad event, Emitter<ChatHistoryState> emit) async {
    emit(ChatHistoryLoading());
    try {
      final response =
          await chatHistoryUseCase.getChatHistory(event.meId, event.frndId);
      emit(ChatHistorySuccess(chatHistoryEntities: response));
    } catch (e) {
      emit(ChatHistoryFailure(message: "$e"));
    }
  }
}
