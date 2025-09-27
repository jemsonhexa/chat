import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  void sendmsg() async {
    final entermsg = messageController.text;

    if (entermsg.trim().isEmpty) {
      return;
    }

    //close keyboard
    FocusScope.of(context).unfocus();
    //clear msg on textfield
    messageController.clear();
    //to get currently loginned user id
    final user = FirebaseAuth.instance.currentUser!;
    //to get username which is alerady ina collection 'users' in auth file
    //get will send http req to firebase to retrieve data in the collection users inside it user.id
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    //send msg to firestore
    //comparing to doc method here we automatically gets automatically generated unique id
    FirebaseFirestore.instance.collection("chat").add({
      "text": entermsg,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "userName": userData
          .data()!['username'], //use same key we used in user collection
      "userImage": userData.data()!['image'],
    });
  }

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(label: Text("Enter chat message")),
            ),
          ),
          IconButton(
            onPressed: sendmsg,
            icon: Icon(Icons.send, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}
