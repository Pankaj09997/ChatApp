import 'package:flutter/material.dart';
import 'package:chatapp/Presentation/StateManagement/FriendList/bloc/friend_list_bloc.dart';
import 'package:chatapp/Presentation/Widgets/TextField.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //calls an event and then show the list of the friend before any other is intansiated
    context.read<FriendListBloc>().add(ShowFriendList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/profile");

            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: BlocListener<FriendListBloc, FriendListState>(
        listener: (context, state) {
          if (state is FriendListNavigateState) {
            Navigator.pushNamed(
              context,
              "/chatroom",
              arguments: {"id": state.id, "name": state.name},
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFormField(
                hintText: "Search for user",
                prefixIcon: Icons.search,
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ),
            //listing the friendlist
            BlocBuilder<FriendListBloc, FriendListState>(
              builder: (context, state) {
                if (state is FriendListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is FriendListSucessState) {
                  //this also is used to list down all the users
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.friendListEntities.length,
                      itemBuilder: (context, index) {
                        final user = state.friendListEntities[index];
                        print("Hello user:$user");
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(user.name ?? "No Name"),
                          subtitle: Text(user.email ?? "No Email"),
                          onTap: () {
                            context.read<FriendListBloc>().add(
                                NavigateToChatRoomEvent(
                                    id: user.id!, name: user.name!));
                          },
                        );
                      },
                    ),
                  );
                } else if (state is FrinedListError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else {
                  return Center(child: Text("Friends List"));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
