import 'dart:convert';

import 'package:chatapp/Data/DataSources/AuthApiService.dart';
import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Presentation/StateManagement/FriendList/bloc/friend_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatRoom extends StatefulWidget {
  final int id; // Friend's ID
  final String name; // Friend's Name

  const ChatRoom({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late WebSocketChannel webSocketChannel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Store messages locally
  String? _token;
  final AuthApiService authApiService=AuthApiService();

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    // Retrieve token (simulate using a dummy token here)
    _token =await authApiService.getToken(); // Replace this with actual token retrieval logic

    if (_token != null) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8000/ws/chat/?token=$_token'),
      );

      webSocketChannel.stream.listen(
        (message) {
          final data = Map<String, dynamic>.from(jsonDecode(message));
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
    if (message.isNotEmpty) {
      final payload = {
        'frnd_id': widget.id,
        'message': message,
      };
      webSocketChannel.sink.add(jsonEncode(payload));
      setState(() {
        _messages.add({'message': message, 'sender': 'You'});
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    webSocketChannel.sink.close(1000);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
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
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['sender'] == 'You';
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['message'],
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }
}
