import 'package:chat_app/services/firebase_api.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/src/app_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 await FirebaseApi().notificationPermission();
  runApp(const AppRoot());
}


// onMessage: When the app is open and it receives a push notification
// replacement for onResume: When the app is in the background and opened directly from the push notification.

