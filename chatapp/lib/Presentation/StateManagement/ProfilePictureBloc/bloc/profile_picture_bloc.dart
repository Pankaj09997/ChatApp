import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Usecases/ProfilePictureUsecase.dart';

import 'package:chatapp/Data/Respositories/ProfileRepository.dart';
import 'package:meta/meta.dart';

part 'profile_picture_event.dart';
part 'profile_picture_state.dart';

class ProfilePictureBloc
    extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final ProfilePictureUseCase profilePictureUseCase;
  ProfilePictureBloc(this.profilePictureUseCase)
      : super(ProfilePictureInitial()) {
    on<UploadProfilePicture>(uploadprofilePictureEvent);
    on<NavigateToHomePage>(navigateToHomePage);
    on<NavigateBack>(navigateBack);
  }
  Future<void> uploadprofilePictureEvent(
      UploadProfilePicture event, Emitter<ProfilePictureState> emit) async {
    // Specific event type
    emit(ProfilePictureLoading());
    try {
      if (event.image == null) {
        throw Exception("No image selected.");
      }

      final response =
          await profilePictureUseCase.uploadProfilePicture(event.image);

      emit(ProfilePictureSuccess(profilePictureEntities: response));
      await Future.delayed(Duration(seconds: 2));
      emit(NavaigateToHomeScreen());
    } catch (e) {
      emit(ProfilePictureFailure(
          message: "Unable to Upload Profile Picture: $e"));
    }
  }

  Future<void> navigateToHomePage(
      ProfilePictureEvent event, Emitter<ProfilePictureState> emit) async {
    emit(NavaigateToHomeScreen());
  }

  Future<void> navigateBack(
      ProfilePictureEvent event, Emitter<ProfilePictureState> emit) async {
    emit(NavigateBackState());
  }
}
