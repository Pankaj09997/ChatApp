import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Entities/UserProfileEntities.dart';
import 'package:chatapp/Business/Usecases/ProfilePictureUsecase.dart';
import 'package:chatapp/Business/Usecases/UserProfileUseCase.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_event.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileUsecase userProfileUsecase;
  final ProfilePictureUseCase profilePictureUseCase;

  UserProfileBloc(this.profilePictureUseCase,
      {required this.userProfileUsecase})
      : super(UserProfileInitial()) {
    on<UserProfileInitialEvent>(_userProfileInitialEvent);
    on<GetUserProfilePicture>(_getUserProfilePicture);
    on<UpdateProfilePicture>(_updateProfilePicture);
  }

  Future<void> _userProfileInitialEvent(
      UserProfileInitialEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final response = await userProfileUsecase.getuserProfile();
      emit(UserProfileSuccess(userProfileEntities: response));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }
Future<void> _getUserProfilePicture(
    GetUserProfilePicture event, Emitter<UserProfileState> emit) async {
  emit(UserProfileLoading());
  try {
    final response = await profilePictureUseCase.getProfilePicture();
    debugPrint("Fetched profile picture response: ${response.data}");

    // Check if response.data is non-null and contains the 'image' key
    if (response.data?.containsKey('image') == true) {
      print("http://127.0.0.1:8000${response.data?['image']}");
      emit(UserProfilePictureGetState(profilePictureEntities: response));
    } else {
      debugPrint("Profile picture URL is not available.");
      emit(UserProfilePictureError(message: "Profile picture URL not available"));
    }
  } catch (e) {
    emit(UserProfilePictureError(message: e.toString()));
  }
}



  Future<void> _updateProfilePicture(
      UpdateProfilePicture event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final response = await profilePictureUseCase
          .updateProfilePicture(event.profilePicture);
      emit(UserProfilePictureUpdateState(profilePictureEntities: response));
    } catch (e) {
      emit(UserProfilePictureError(message: e.toString()));
    }
  }
}
