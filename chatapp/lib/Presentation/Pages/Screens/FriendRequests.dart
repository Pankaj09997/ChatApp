import 'package:chatapp/Presentation/StateManagement/FriendRequests/bloc/friend_requests_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  void initState() {
    context.read<FriendRequestsBloc>().add(FriendRequestList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: BlocListener<FriendRequestsBloc, FriendRequestsState>(
        listener: (context, state) {
          if (state is NavigateBackState) {
            Navigator.pop(context);
          } else if (state is FriendRequestListError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<FriendRequestsBloc, FriendRequestsState>(
                builder: (context, state) {
                  if (state is FriendRequestListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FriendRequestListSuccess) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.friendRequestList.length,
                      itemBuilder: (context, index) {
                        final friend = state.friendRequestList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Profile Picture
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: NetworkImage(
                                    "https://i.pinimg.com/474x/6d/0e/05/6d0e052a59840858186a37ba74de24b3.jpg",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Friend Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        friend.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        friend.email,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Action Buttons
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<FriendRequestsBloc>()
                                            .add(AcceptFriendRequest(
                                                receiver_id: friend.id));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text("Accept"),
                                    ),
                                    const SizedBox(height: 8),
                                    OutlinedButton(
                                      onPressed: () {
                                        // Handle Decline
                                       
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            const BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Decline",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FriendRequestListError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("No friend requests available."),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
