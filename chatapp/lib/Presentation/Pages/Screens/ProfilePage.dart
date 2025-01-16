import 'package:chatapp/Data/DataSources/ProfilePicture.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_event.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String baseUrl = "http://127.0.0.1:8000"; // Update this for deployment.

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(UserProfileInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileSuccess) {
              final profile = state.userProfileEntities;
              final formattedDate = profile.last_login != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(profile.last_login!)
                  : "Not Available";

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    _buildProfilePicture(context),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              profile.name!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.email!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Last Login:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else if (state is UserProfileError) {
              return _buildErrorSection(context, state.message);
            }
            return const Center(child: Text("No data available."));
          },
        ),
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    final ProfilePictureService profilePictureService = ProfilePictureService();

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfilePictureGetState) {
          final profilePictureUrl = state.profilePictureEntities.data?['image'];
          final fullImageUrl =
              profilePictureUrl != null ? "$baseUrl$profilePictureUrl" : null;

          return CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            backgroundImage:
                fullImageUrl != null ? NetworkImage(fullImageUrl) : null,
            child: fullImageUrl == null
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          );
        } else if (state is UserProfilePictureError) {
          return const CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            child: Icon(Icons.error, color: Colors.red),
          );
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: profilePictureService.getProfilePicture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(
                radius: 80,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const CircleAvatar(
                radius: 80,
                child: Icon(Icons.error, color: Colors.red),
              );
            } else if (snapshot.hasData) {
              final profilePictureUrl = snapshot.data?['data']?['image'];
              final fullImageUrl =
                  profilePictureUrl != null ? "$baseUrl$profilePictureUrl" : null;

              return CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                backgroundImage: fullImageUrl != null
                    ? NetworkImage(fullImageUrl)
                    : null,
              );
            } else {
              return const CircleAvatar(
                radius: 80,
                child: Icon(Icons.person, size: 60, color: Colors.grey),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildErrorSection(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Error: $message",
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context.read<UserProfileBloc>().add(UserProfileInitialEvent());
              context.read<UserProfileBloc>().add(GetUserProfilePicture());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
