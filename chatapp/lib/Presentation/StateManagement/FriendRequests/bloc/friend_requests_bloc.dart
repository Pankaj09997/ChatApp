import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/FriendRequestEntity.dart';
import 'package:chatapp/Business/Usecases/FriendRequestUseCase.dart';
import 'package:meta/meta.dart';

part 'friend_requests_event.dart';
part 'friend_requests_state.dart';

class FriendRequestsBloc
    extends Bloc<FriendRequestsEvent, FriendRequestsState> {
  final FriendRequestUseCase friendRequestUseCase;
  FriendRequestsBloc(this.friendRequestUseCase)
      : super(FriendRequestsInitial()) {
    on<FriendRequestList>(friendRequestList);
    on<AcceptFriendRequest>(acceptFriendRequest);
    on<NavigateBack>(navigateBack);
  }
  Future<void> friendRequestList(
      FriendRequestList event, Emitter<FriendRequestsState> emit) async {
    try {
      emit(FriendRequestListLoading());
      final response = await friendRequestUseCase.friendRequestList();
      emit(FriendRequestListSuccess(friendRequestList: response));
    } catch (e) {
      emit(FriendRequestListError(message: "$e"));
    }
  }

  Future<void> acceptFriendRequest(
      AcceptFriendRequest event, Emitter<FriendRequestsState> emit) async {
    try {
      emit(AcceptFriendRequestLoading());
      final response =
          await friendRequestUseCase.acceptFriendRequest(event.receiver_id);
      emit(AcceptFriendRequestSuccess(acceptFriendRequestEntity: response));
    } catch (e) {
      print("$e");
      emit(FriendRequestListError(message: "Error:$e"));
    }
  }

  Future<void> navigateBack(
      NavigateBack event, Emitter<FriendRequestsState> emit) async {
    emit(NavigateBackState());
  }
}
