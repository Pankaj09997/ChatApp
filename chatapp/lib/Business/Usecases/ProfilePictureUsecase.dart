import 'dart:io';

import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';
import 'package:chatapp/Business/Repositories/ProfileRepository.dart';

class ProfilePictureUseCase {
  final ProfileRepository profileRepository;

  ProfilePictureUseCase({required this.profileRepository});

  Future<ProfilePictureEntities> getProfilePicture() async {
    return await profileRepository.getProfilePicture();
  }

  Future<ProfilePictureEntities> updateProfilePicture(File? image) async {
    return await profileRepository.updateProfilePicture(image);
  }

  Future<ProfilePictureEntities> uploadProfilePicture(File? image) async {
    return await profileRepository.uploadProfilePicture(image);
  }

  Future<ProfilePictureEntities> deleteProfilePicture() async {
    return await profileRepository.deleteProfilePicture();
  }
}
