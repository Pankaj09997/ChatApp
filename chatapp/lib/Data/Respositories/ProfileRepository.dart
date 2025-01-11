import 'dart:io';

import 'package:chatapp/Data/DataSources/ProfilePicture.dart';
import 'package:chatapp/Data/models/ProfileModels.dart';

class ProfilePictureRepository {
  final ProfilePictureService profilePictureService;

  ProfilePictureRepository({required this.profilePictureService});
//getting the profile picture of the user
  Future<ProfilePicture> getprofilePicture() async {
    try {
      final response = await profilePictureService.getProfilePicture();
      return ProfilePicture.fromJson(response);
    } catch (e) {
      throw Exception("Error:$e");
    }
  }

  //uploading the profile picture
  Future<ProfilePicture> uploadProfilePicture(File? profile) async {
    try {
      final response =
          await profilePictureService.uploadProfilePicture(profile);
      return ProfilePicture.fromJson(response);
    } catch (e) {
      throw Exception("Error:$e");
    }
  }

  //updating the profile picture
  Future<ProfilePicture> updateProfilePicture(File? profile) async {
    try {
      final response =
          await profilePictureService.updateProfilePicture(profile);
      return ProfilePicture.fromJson(response);
    } catch (e) {
      throw Exception("Error:$e");
    }
  }

//delete the profile picture
  Future<ProfilePicture> deleteProfilePicture() async {
    try {
      final response = await profilePictureService.deleteProfilePicture();
      return ProfilePicture.fromJson(response);
    } catch (e) {
      throw Exception("Error:$e");
    }
  }
}
