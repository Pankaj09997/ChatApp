// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/FriendListEntities.dart';
import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Usecases/FriendListUseCase.dart';
import 'package:chatapp/Business/Usecases/ProfilePictureUsecase.dart';
import 'package:chatapp/Presentation/StateManagement/UserSearch/bloc/user_search_bloc.dart';
import 'package:meta/meta.dart';

part 'friend_list_event.dart';
part 'friend_list_state.dart';

class FriendListBloc extends Bloc<FriendListEvent, FriendListState> {
  final FriendListUseCase friendListUseCase;
  final ProfilePictureUseCase profilePictureUseCase;

  FriendListBloc(
    this.friendListUseCase,
    this.profilePictureUseCase,
  ) : super(FriendListInitial()) {
    on<NavigateToChatRoomEvent>(navigateToChatRoomEvent);
    on<ShowFriendList>(showFriendList);
  }
  Future<void> navigateToChatRoomEvent(
      NavigateToChatRoomEvent event, Emitter<FriendListState> emit) async {
    emit(FriendListLoading());
    try {
      emit(FriendListNavigateState(event.name, id: event.id));
    } catch (e) {
      emit(FrinedListError(message: "$e"));
    }
  }

  Future<void> showFriendList(
      ShowFriendList event, Emitter<FriendListState> emit) async {
    emit(FriendListLoading());
    try {
      final response = await friendListUseCase.getFriendList();
      final profilePicture = await profilePictureUseCase.getProfilePicture();
      emit(FriendListSucessState(profilePictureEntities: profilePicture,friendListEntities: response));
    } catch (e) {
      emit(FrinedListError(message: "$e"));
    }
  }
}
