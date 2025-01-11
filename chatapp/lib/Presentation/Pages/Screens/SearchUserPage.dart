import 'package:chatapp/Presentation/StateManagement/SendFriendRequest/bloc/send_friend_request_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserSearch/bloc/user_search_bloc.dart';
import 'package:chatapp/Presentation/Widgets/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController emailController = TextEditingController();
  //for keeping the search bar active 
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //during the execution of the page it will be kept in the focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    emailController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    emailController.removeListener(_onSearchChanged);
    emailController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      context.read<UserSearchBloc>().add(UserSearchType(email: email));
    } else {
      context.read<UserSearchBloc>().add(UserSearchClear());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: BlocListener<UserSearchBloc, UserSearchState>(
        listener: (context, state) {
          if (state is UserSearchFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  prefixIcon: Icons.search,
                  hintText: "Search Your Friends",
                  controller: emailController,
                  focusNode: _focusNode,
                ),
              ),
              SizedBox(height: height * 0.02),
              BlocBuilder<UserSearchBloc, UserSearchState>(
                builder: (context, state) {
                  if (state is UserSearchLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is UserSearchSuccess) {
                    if (state.usersearchentities.isEmpty) {
                      return const Text("No users found.");
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.usersearchentities.length,
                      itemBuilder: (context, index) {
                        final user = state.usersearchentities[index];
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(user.name ?? 'Guest'),
                          subtitle: Text(user.email ?? ''),
                          trailing: user.is_friend
                              ? const Text("Friend")
                              : user.friend_request_sent
                                  ? const Text("Request Sent")
                                  : ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<SendFriendRequestBloc>()
                                            .add(SendFriendRequest(
                                              receiverId: user.id,
                                            ));
                                      },
                                      child: const Text("Add Friend"),
                                    ),
                          onTap: () {
                            context
                                .read<UserSearchBloc>()
                                .add(SearchedUserNavigate(email: user.email));
                          },
                        );
                      },
                    );
                  } else if (state is UserSearchFailure) {
                    return Text("Error: ${state.message}");
                  }
                  return const Text("Search for a user by email");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
