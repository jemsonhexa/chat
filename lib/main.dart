import 'package:chtapp/screens/auth.dart';
import 'package:chtapp/screens/chat_screen.dart';
import 'package:chtapp/screens/snackbar.dart';
import 'package:chtapp/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackbarService.messengerKey,
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      ),
      //if token got then go to chat screen else auth screen
      home: StreamBuilder(
        //similar to future builder but in fbuilder once
        //the future func completes it will have only one
        // value /error where in streambuilder
        //will produce multiple values at the end.
        stream: FirebaseAuth.instance
            .authStateChanges(), //once token becomes available
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const ChatScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
