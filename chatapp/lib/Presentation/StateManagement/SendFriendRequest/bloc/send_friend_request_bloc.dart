import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/SendFriendRequestEntities.dart';
import 'package:chatapp/Business/Usecases/SendFriendRequestUseCase.dart';
import 'package:chatapp/Presentation/StateManagement/UserSearch/bloc/user_search_bloc.dart';
import 'package:meta/meta.dart';

part 'send_friend_request_event.dart';
part 'send_friend_request_state.dart';

class SendFriendRequestBloc
    extends Bloc<SendFriendRequestEvent, SendFriendRequestState> {
  final SendFriendRequestUseCase sendFriendRequestUseCase;
  final UserSearchBloc userSearchBloc; // Inject UserSearchBloc

  SendFriendRequestBloc({
    required this.sendFriendRequestUseCase,
    required this.userSearchBloc,
  }) : super(SendFriendRequestInitial()) {
    on<SendFriendRequest>(_sendFriendRequest);
  }

  Future<void> _sendFriendRequest(
      SendFriendRequest event, Emitter<SendFriendRequestState> emit) async {
    emit(SendFriendRequestLoading());
    try {
      final response = await sendFriendRequestUseCase
          .sendFriendRequestUseCase(event.receiverId);
      emit(FriendRequestSentSuccess(sendFriendRequestEntities: response));

      // Notify UserSearchBloc to update the UI
      userSearchBloc.add(UpdateUserRequestSent(userId: event.receiverId));
    } catch (e) {
      emit(SendFriendRequestError(message: e.toString()));
    }
  }
}
