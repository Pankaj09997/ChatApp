import 'package:chatapp/Presentation/StateManagement/ProfilePictureBloc/bloc/profile_picture_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch the user profile
    context.read<UserProfileBloc>().add(UserProfileInitialEvent());
    context.read<UserProfileBloc>().add(GetUserProfilePicture());
    
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://127.0.0.1:8000";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserProfileSuccess) {
              final profile = state.userProfileEntities;

              // Handle nullable last_login and check if it's null
              String formattedDate = "Not Available"; // Default message if null
              if (profile.last_login != null) {
                // Format the last_login DateTime to a String
                formattedDate =
                    DateFormat('yyyy-MM-dd HH:mm').format(profile.last_login!);
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    BlocBuilder<UserProfileBloc, UserProfileState>(
                        builder: (context, state) {
                      if (state is UserProfilePictureLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is UserProfilePictureError) {
                        return const CircleAvatar(
                          radius: 120,
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      } else if (state is UserProfilePictureGetState) {
                        final profilePicture =
                            state.profilePictureEntities.data;
                        print("$profilePicture");
                        String imageUrl = "$baseUrl${profilePicture?['image']}";
                        print("image url is :$imageUrl");

                        return CircleAvatar(
                          radius: 120,
                          backgroundImage: profilePicture != null
                              ? NetworkImage(imageUrl)
                              : null,
                          child: profilePicture == null
                              ? const Icon(Icons.person)
                              : null,
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 120,
                          child: Icon(Icons.person),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    // Name Section
                    Text(
                      "Name: ${profile.name}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email Section

                    Text(
                      "Email: ${profile.email}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Last Login Section
                    Text(
                      "Last Login: $formattedDate",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Button to update profile or settings
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
            // Return this if no specific state matches
            return const Center(
              child: Text("No data available."),
            );
          },
        ),
      ),
    );
  }
}
