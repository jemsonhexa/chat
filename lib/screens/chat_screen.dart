import 'package:chtapp/widgets/chat_messages.dart';
import 'package:chtapp/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        spacing: 10,
        children: [
          Expanded(child: ChatMessages()), //takes as much as space it wants
          NewMessages(),
        ],
      ),
    );
  }
}
