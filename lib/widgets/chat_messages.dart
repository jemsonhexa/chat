import 'package:chtapp/widgets/chat_bubles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    //cureent user
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          ) //order the data based on created time
          .snapshots(), //whenever chat db in firestore gets updated
      builder: (context, snapshot) {
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
        final loadedData = snapshot.data!.docs;
        return ListView.builder(
          reverse: true, //to  show items in the bottom instead of top
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 12),
          itemCount: loadedData.length,
          itemBuilder: (cxt, index) {
            final chatmsgDetails = loadedData[index].data();
            final nextChatmsg = index + 1 < loadedData.length
                ? loadedData[index + 1].data()
                : null;
            final currentMsgUid = chatmsgDetails['userId'];
            final nextMsgUid = nextChatmsg != null
                ? nextChatmsg['userid']
                : null;

            final isNextmsgUserSame = nextMsgUid == currentMsgUid;

            if (isNextmsgUserSame) {
              return MessageBubble.next(
                message: chatmsgDetails['text'],
                isMe: authenticatedUser.uid == currentMsgUid,
              );
            } else {
              return MessageBubble.first(
                userImage: chatmsgDetails['userImage'],
                username: chatmsgDetails['userName'],
                message: chatmsgDetails['text'],
                isMe: authenticatedUser.uid == currentMsgUid,
              );
            }
          },
        );
      },
    );
  }
}
