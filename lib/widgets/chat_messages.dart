import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: false,
          ) //order the data based on created time
          .snapshots(), //whenever chat db in firestore gets updated
      builder: (context, snapshot) {
        final loadedData = snapshot.data!.docs;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No chats"),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong!!!"));
        }
        return ListView.builder(
          itemCount: loadedData.length,
          itemBuilder: (cxt, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(loadedData[index].data()['text']),
            );
          },
        );
      },
    );

    // return Center(child: Text("No data"));
  }
}
