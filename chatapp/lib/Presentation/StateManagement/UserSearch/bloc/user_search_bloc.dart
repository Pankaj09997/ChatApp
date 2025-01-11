import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/UserSearchEntities.dart';
import 'package:chatapp/Business/Usecases/UserSearchUseCase.dart';
import 'package:meta/meta.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final UserSearchUseCase _userSearchUseCase;

  UserSearchBloc(this._userSearchUseCase) : super(UserSearchInitial()) {
    on<UserSearchType>(userSearchType);
    on<SearchedUserNavigate>(searchedUserNavigate);
    on<UserSearchClear>(userSearchClear);
    on<UpdateUserRequestSent>(updateUserRequestSent);
  }

  // Handles user search by email
  Future<void> userSearchType(
      UserSearchType event, Emitter<UserSearchState> emit) async {
    emit(UserSearchLoading());
    try {
      final response = await _userSearchUseCase.userSearchUseCase(event.email!);
      emit(UserSearchSuccess(usersearchentities: response));
    } catch (e) {
      emit(UserSearchFailure(message: "$e"));
    }
  }

  // Handles navigation to a searched user
  Future<void> searchedUserNavigate(
      SearchedUserNavigate event, Emitter<UserSearchState> emit) async {
    try {
      emit(UserSearchLoading());
      emit(UserSearchNavigateSuccess(email: event.email!));
    } catch (e) {
      emit(UserNavigateFailure(errorMessage: "$e"));
    }
  }

  // Resets the state to initial
  Future<void> userSearchClear(
      UserSearchClear event, Emitter<UserSearchState> emit) async {
    emit(UserSearchInitial());
  }

  // Updates the friend request status for a specific user
Future<void> updateUserRequestSent(
    UpdateUserRequestSent event, Emitter<UserSearchState> emit) async {
  if (state is UserSearchSuccess) {
    final currentState = state as UserSearchSuccess;

    final updatedUsers = currentState.usersearchentities.map((user) {
      if (user.id == event.userId) {
        return user.copyWith(friend_request_sent: true);
      }
      return user;
    }).toList();

    emit(UserSearchSuccess(usersearchentities: updatedUsers));
  }
}


}
