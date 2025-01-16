import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Entities/UserProfileEntities.dart';
import 'package:flutter/material.dart';

/// BLoC State Definitions
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

final class UserProfilePictureError extends UserProfileState {
  final String message;

  UserProfilePictureError({required this.message});
}
