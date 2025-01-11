part of 'profile_picture_bloc.dart';

@immutable
sealed class ProfilePictureEvent {}

final class UploadProfilePicture extends ProfilePictureEvent {
  final File? image;

  UploadProfilePicture({required this.image});
}

final class NavigateToHomePage extends ProfilePictureEvent {}
final class NavigateBack extends ProfilePictureEvent{}
