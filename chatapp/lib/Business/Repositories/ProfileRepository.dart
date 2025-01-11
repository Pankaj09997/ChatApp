import 'dart:io';
import 'package:chatapp/Business/Entities/ProfilePictureEntities.dart';

import 'package:chatapp/Data/DataSources/ProfilePicture.dart';
import 'package:chatapp/Data/models/ProfileModels.dart';

abstract class ProfileRepository {
  Future<ProfilePictureEntities> uploadProfilePicture(File? image);
  Future<ProfilePictureEntities> getProfilePicture();
  Future<ProfilePictureEntities> deleteProfilePicture();
  Future<ProfilePictureEntities> updateProfilePicture(File? image);
}

class ProfileUploadRepositoryImpl implements ProfileRepository {
  final ProfilePictureService _profileApiService;

  ProfileUploadRepositoryImpl(this._profileApiService);

  @override
  Future<ProfilePictureEntities> uploadProfilePicture(File? image) async {
    // Step 1: Fetch raw data from API
    final response = await _profileApiService.uploadProfilePicture(image);

    // Step 2: Map API response to a data model
    final profilePictureModel = ProfilePicture.fromJson(response);

    // Step 3: Map the data model to a domain entity
    return ProfilePictureEntities(
      status: profilePictureModel.status,
      data: profilePictureModel.data,
      message: profilePictureModel.message,
      response: profilePictureModel.response,
    );
  }

  Future<ProfilePictureEntities> getProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> deleteProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> updateProfilePicture(File? image) async {
    throw UnimplementedError();
  }
}

class ProfileGetRepositoryImpl implements ProfileRepository {
  final ProfilePictureService _profileApiService;

  ProfileGetRepositoryImpl(this._profileApiService);

  @override
  Future<ProfilePictureEntities> uploadProfilePicture(File? image) async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> getProfilePicture() async {
    final response = await _profileApiService.getProfilePicture();
    final getModel = ProfilePicture.fromJson(response);
    return ProfilePictureEntities(
        status: getModel.status,
        data: getModel.data,
        message: getModel.message,
        response: getModel.response);
  }

  Future<ProfilePictureEntities> deleteProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> updateProfilePicture(File? image) async {
    throw UnimplementedError();
  }
}

class ProfileUpdateRepositoryImpl implements ProfileRepository {
  final ProfilePictureService _profileApiService;

  ProfileUpdateRepositoryImpl(this._profileApiService);

  @override
  Future<ProfilePictureEntities> uploadProfilePicture(File? image) async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> getProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> deleteProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> updateProfilePicture(File? image) async {
    final response = await _profileApiService.updateProfilePicture(image);
    final userData = ProfilePicture.fromJson(response);
    return ProfilePictureEntities(
        status: userData.status,
        data: userData.data,
        message: userData.message,
        response: userData.response);
  }
}

class ProfileDeleteRepositoryImpl implements ProfileRepository {
  final ProfilePictureService _profileApiService;

  ProfileDeleteRepositoryImpl(this._profileApiService);

  @override
  Future<ProfilePictureEntities> uploadProfilePicture(File? image) async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> getProfilePicture() async {
    throw UnimplementedError();
  }

  Future<ProfilePictureEntities> deleteProfilePicture() async {
    final response = await _profileApiService.deleteProfilePicture();
    final userData = ProfilePicture.fromJson(response);
    return ProfilePictureEntities(
        status: userData.status,
        data: userData.data,
        message: userData.message,
        response: userData.response);
  }

  Future<ProfilePictureEntities> updateProfilePicture(File? image) async {
    throw UnimplementedError();
  }
}
