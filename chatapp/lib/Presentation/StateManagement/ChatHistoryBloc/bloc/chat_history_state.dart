part of 'chat_history_bloc.dart';

@immutable
sealed class ChatHistoryState {}

final class ChatHistoryInitial extends ChatHistoryState {}

final class ChatHistoryLoading extends ChatHistoryState {}

final class ChatHistoryFailure extends ChatHistoryState {
  final String message;

  ChatHistoryFailure({required this.message});
}

final class ChatHistorySuccess extends ChatHistoryState {
  final List<ChatHistoryEntities> chatHistoryEntities;

  ChatHistorySuccess({required this.chatHistoryEntities});
}
