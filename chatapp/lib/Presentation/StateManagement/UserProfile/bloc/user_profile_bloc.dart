import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Entities/UserProfileEntities.dart';
import 'package:chatapp/Business/Usecases/ProfilePictureUsecase.dart';
import 'package:chatapp/Business/Usecases/UserProfileUseCase.dart';
import 'package:chatapp/Data/models/ProfileModels.dart';
import 'package:meta/meta.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileUsecase userProfileUsecase;
  final ProfilePictureUseCase profilePictureUseCase;
  UserProfileBloc(this.profilePictureUseCase,
      {required this.userProfileUsecase})
      : super(UserProfileInitial()) {
    on<UserProfileInitialEvent>(userProfileInitialEvent);
    on<GetUserProfilePicture>(getUserProfilePicture);
    on<UpdateProfilePicture>(updateProfilePicture);
  }
  Future<void> userProfileInitialEvent(
      UserProfileInitialEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final response = await userProfileUsecase.getuserProfile();
      emit(UserProfileSuccess(userProfileEntities: response));
    } catch (e) {
      emit(UserProfileError(message: "$e"));
    }
  }

  Future<void> getUserProfilePicture(
      GetUserProfilePicture event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    final response = await profilePictureUseCase.getProfilePicture();
    emit(UserProfilePictureGetState(profilePictureEntities: response));
  }

  Future<void> updateProfilePicture(
      UpdateProfilePicture event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final response = await profilePictureUseCase
          .updateProfilePicture(event.profilePicture);
      emit(UserProfilePictureUpdateState(profilePictureEntities: response));
    } catch (e) {
      emit(UserProfilePictureError(message: "$e"));
    }
  }
}
