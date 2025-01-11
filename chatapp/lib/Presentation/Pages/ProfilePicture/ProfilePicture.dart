import 'dart:io';

import 'package:chatapp/Presentation/StateManagement/ProfilePictureBloc/bloc/profile_picture_bloc.dart';
import 'package:chatapp/Presentation/Widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _selectedImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      print('Dispatching event');
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No Images Selected"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    body: BlocListener<ProfilePictureBloc, ProfilePictureState>(
      listener: (context, state) {
        if (state is NavigateBackState) {
          Navigator.pop(context);
        } else if (state is NavaigateToHomeScreen) {
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Column(
        children: [
          SizedBox(height: height * 0.08),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 196, 196),
                  borderRadius: BorderRadius.circular(150),
                ),
                child: _selectedImage == null
                    ? Image.asset(
                        "asset/person.png",
                        height: height * 0.3,
                      )
                    : ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          height: height * 0.3,
                          width: height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: height * 0.03),
          const Text(
            "Upload Your Profile Picture",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          BlocBuilder<ProfilePictureBloc, ProfilePictureState>(
            builder: (context, state) {
              final isLoading = state is ProfilePictureLoading;

              return Column(
                children: [
                  if (isLoading) const CircularProgressIndicator(),
                  CustomButton(
                    text: "Upload",
                    onTap: () {
                      if (_selectedImage != null) {
                        context
                            .read<ProfilePictureBloc>()
                            .add(UploadProfilePicture(image: _selectedImage));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select an image first."),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: AbsorbPointer(
                      absorbing: isLoading, // Block interaction during loading
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<ProfilePictureBloc>()
                                  .add(NavigateBack());
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_back, color: Colors.blue),
                                Text(
                                  "Back To Previous Page",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<ProfilePictureBloc>()
                                  .add(NavigateToHomePage());
                            },
                            child: Row(
                              children: const [
                                Text(
                                  "Skip",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Icon(Icons.arrow_right, color: Colors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

}
