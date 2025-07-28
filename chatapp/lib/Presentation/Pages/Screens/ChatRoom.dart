import 'dart:convert';

import 'package:chatapp/Data/DataSources/AuthApiService.dart';
import 'package:chatapp/Presentation/StateManagement/ChatHistoryBloc/bloc/chat_history_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/FriendList/bloc/friend_list_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_event.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRoom extends StatefulWidget {
  final int id; // Friend's ID
  final String name; // Friend's Name

  const ChatRoom({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // channel creation so that user can communicate with the server.
  late WebSocketChannel webSocketChannel;
  final TextEditingController _messageController = TextEditingController();
  //storing the message that is current message that the user have sent recently.
  final List<Map<String, dynamic>> _messages = [];
  String? _token;
  int? _userId; // Authenticated user's ID
  final AuthApiService authApiService = AuthApiService();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(UserProfileInitialEvent());
    _initWebSocket();
  }
//fetching the history of the chats that are done 
  void _fetchChatHistory() async {
    //to get the id of the current user
    final userProfileState = context.read<UserProfileBloc>().state;

    if (userProfileState is UserProfileSuccess) {
      //get the id of the curretly authenticated User
      _userId = userProfileState.userProfileEntities.id;
//check if the user id is not null or not 
      if (_userId != null) {
        context
            .read<ChatHistoryBloc>()
            .add(ChatHistoryLoad(meId: _userId!, frndId: widget.id));
      }
    } else {
      print("UserProfileBloc is not in a success state.");
    }
  }

  Future<void> _initWebSocket() async {
    //get the token of the currently authenticated user
    _token = await authApiService.getToken();

    if (_token != null) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8000/ws/chat/?token=$_token'),
      );
//listen if any new messages are coming to the websocket
      webSocketChannel.stream.listen(
        //message is a callback function that is triggered everytime new message is received
        //CallBack function is a kind of function that is called when the certain task is completed and it notifies you that the task has been completed.
        //definition of callback function is the function that is called inside the function as an argument that notifies us when some task is completed.
        (message) {
          //converting the data that is in the server to the dart objects that is in the Map<String,dynamic>
          final data = Map<String, dynamic>.from(jsonDecode(message));
          //rebuilding the ui when the message are added into it So the UI shows history + current session messages together so that it would not load for long time to restore the history of the chat
          setState(() {
            _messages.add({
              'message': data['message'],
              'sender': data['sender'],
            });
          });
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket closed');
        },
      );
    } else {
      print("Invalid token, unable to connect to WebSocket");
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty && _userId != null) {
      final payload = {
        'frnd_id': widget.id,
        'message': message,
        'sender': _userId,
      };
      //to send the data to the server sink.add() is used
      webSocketChannel.sink.add(jsonEncode(payload));
      setState(() {
        _messages.add({'message': message, 'sender': _userId});
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    //telling the server we have closed the server normally that is not because of any error it is very important to tell the server why we are closing the server and 1000 does that
    webSocketChannel.sink.close(1000);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSuccess) {
          _userId = state.userProfileEntities.id;
          _fetchChatHistory();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          context.read<FriendListBloc>().add(ShowFriendList());
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
            backgroundColor: Colors.teal,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                  builder: (context, state) {
                    if (state is ChatHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatHistoryFailure) {
                      return Center(
                        child: Text(
                          "Failed to load chat history: ${state.message}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is ChatHistorySuccess) {
                      final chatHistory = state.chatHistoryEntities.map((entity) {
                        return {
                          'message': entity.message,
                          'sender': entity.sender_id,
                          'timestamp': entity.timestamp,
                        };
                      }).toList();

                      final allMessages = [...chatHistory, ..._messages];

                      return ListView.builder(
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          final message = allMessages[index];
                          final isMe = message['sender'] == _userId;

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text("No chat history available."),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.teal),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
