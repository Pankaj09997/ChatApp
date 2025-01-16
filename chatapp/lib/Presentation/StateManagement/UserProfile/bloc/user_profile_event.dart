import 'dart:io';

import 'package:flutter/material.dart';

/// BLoC Event Definitions
@immutable
sealed class UserProfileEvent {}

final class UserProfileInitialEvent extends UserProfileEvent {}

final class GetUserProfilePicture extends UserProfileEvent {}

final class UpdateProfilePicture extends UserProfileEvent {
  final File? profilePicture;

  UpdateProfilePicture({required this.profilePicture});
}
