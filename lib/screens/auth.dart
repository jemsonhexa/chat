import 'dart:io';

import 'package:chtapp/screens/snackbar.dart';
import 'package:chtapp/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

final formKey = GlobalKey<FormState>();
var isLogin = true;
var isAuthenticating = false;
var emailEntered = '';
var pwdEntered = '';
var uNameEntered = '';
File? selectedImg;

class _AuthScreenState extends State<AuthScreen> {
  void submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid || selectedImg == null && !isLogin) {
      return;
    }
    formKey.currentState!.save();
    // print(pwdEntered);
    try {
      if (isLogin) {
        setState(() {
          isAuthenticating = true;
        });

        //log users in
        final userCredentials = await firebase.signInWithEmailAndPassword(
          //here when user sign in a token will be granted
          email: emailEntered,
          password: pwdEntered,
        );
        print(userCredentials);
      } else {
        //sign up

        final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: emailEntered,
          password: pwdEntered,
        );
        print(userCredentials);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(
              "${userCredentials.user!.uid}.jpg",
            ); //puting image  in a folder user_images

        await storageRef.putFile(selectedImg!); //to store img to storage
        final imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
              "username": uNameEntered,
              "email": emailEntered,
              "image": imageUrl,
            });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}

      SnackbarService.show("Check Your Credentials !!!");
    }

    setState(() {
      isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLogin)
                          ImagePickerWidget(
                            onImageSelected: (pickedImg) {
                              selectedImg = pickedImg;
                            },
                          ),
                        if (!isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Username"),
                            ),
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().length < 4) {
                                return 'Enter a valid namel';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              uNameEntered = newValue!;
                            },
                          ),
                        TextFormField(
                          decoration: InputDecoration(label: Text("Email")),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            emailEntered = newValue!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(label: Text("Password")),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Enter a valid password';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            pwdEntered = newValue!;
                          },
                        ),
                        SizedBox(height: 15),
                        if (isAuthenticating)
                          const CircularProgressIndicator(strokeWidth: 2),
                        if (!isAuthenticating)
                          ElevatedButton(
                            onPressed: submit,
                            child: Text(isLogin ? "SignIn" : "SignUp"),
                          ),
                        if (!isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin; //checks for opposite
                              });
                            },
                            child: Text(
                              isLogin
                                  ? "Create account"
                                  : "Already have account?",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
