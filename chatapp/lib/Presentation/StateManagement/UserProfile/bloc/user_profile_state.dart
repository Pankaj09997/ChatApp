part of 'user_profile_bloc.dart';

@immutable
sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileSuccess extends UserProfileState {
  final UserProfileEntities userProfileEntities;

  UserProfileSuccess({required this.userProfileEntities});
}

final class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError({required this.message});
}

final class UserProfilePictureGetState extends UserProfileState {
  final ProfilePictureEntities profilePictureEntities;

  UserProfilePictureGetState({required this.profilePictureEntities});
}

final class UserProfilePictureUpdateState extends UserProfileState {
  final ProfilePictureEntities profilePictureEntities;

  UserProfilePictureUpdateState({required this.profilePictureEntities});
}

final class UserProfilePictureLoading extends UserProfileState {}

final class UserProfilePictureError extends UserProfileState {
  final String message;

  UserProfilePictureError({required this.message});
}
