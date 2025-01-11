part of 'profile_picture_bloc.dart';

@immutable
sealed class ProfilePictureState {}

final class ProfilePictureInitial extends ProfilePictureState {}

final class ProfilePictureSuccess extends ProfilePictureState {
  final ProfilePictureEntities profilePictureEntities;

  ProfilePictureSuccess({required this.profilePictureEntities});
}

final class ProfilePictureFailure extends ProfilePictureState {
  final String message;

  ProfilePictureFailure({required this.message});
}

final class ProfilePictureLoading extends ProfilePictureState {}

final class NavaigateToHomeScreen extends ProfilePictureState {}
final class NavigateBackState extends ProfilePictureState{}
