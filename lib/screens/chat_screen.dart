import 'package:chtapp/widgets/chat_messages.dart';
import 'package:chtapp/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fbm = FirebaseMessaging.instance;
    await fbm.requestPermission();
    final token = await fbm.getToken(); // this can be send via http to db
    // print("token");
    // print(token);
    fbm.subscribeToTopic(
      'chat',
    ); // this should be same as firebase msging topic so that every device will get notifications
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

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
