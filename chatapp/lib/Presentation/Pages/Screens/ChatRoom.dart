import 'package:chatapp/Presentation/StateManagement/FriendList/bloc/friend_list_bloc.dart';
import 'package:chatapp/Presentation/Widgets/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  final int id;
  final String name;

  const ChatRoom({super.key, required this.id, required this.name});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.read<FriendListBloc>().add(ShowFriendList());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(0, 247, 247, 247),
          elevation: 0,
        ),
        extendBodyBehindAppBar: true, // Allow the app bar to overlap with the background
        body: Stack(
          children: [
            // Camera Background (Placeholder)


            // Chat Input Overlay
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                 // Semi-transparent background
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    // Camera Icon
                    IconButton(
                      onPressed: () {
                        // Handle camera action
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.black),
                    ),

                    // Chat Input Field
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "Chat",
                       // Adjusted for visibility
                      ),
                    ),

                    // Send Icon
                    IconButton(
                      onPressed: () {
                        // Handle send action
                      },
                      icon: const Icon(Icons.send, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
