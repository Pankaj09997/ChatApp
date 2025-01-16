part of 'chat_history_bloc.dart';

@immutable
sealed class ChatHistoryEvent {}

final class ChatHistoryLoad extends ChatHistoryEvent {
  final int meId;
  final int frndId;

  ChatHistoryLoad({required this.meId, required this.frndId});
}
