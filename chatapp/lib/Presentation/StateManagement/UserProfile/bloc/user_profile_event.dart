part of 'user_profile_bloc.dart';

@immutable
sealed class UserProfileEvent {}

final class UserProfileInitialEvent extends UserProfileEvent {}

final class GetUserProfilePicture extends UserProfileEvent {}

final class UpdateProfilePicture extends UserProfileEvent {
  final File? profilePicture;

  UpdateProfilePicture({required this.profilePicture});
}
