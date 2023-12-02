import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helper/show_snack_bar.dart';
import '../model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
const String defaultUserImg =
    "https://firebasestorage.googleapis.com/v0/b/dms-system-c66ea.appspot.com/o/defaultDriver.png?alt=media&token=6d888380-de84-4543-8335-418002346571";

Future createUser(UserModel newUser, User? currentUser) async {
  if (newUser.imageURL != null) {
    newUser.imageURL =
        await getStorageImgURL(currentUser!.uid, newUser.imageURL);
  } else {
    // Set default image
    newUser.imageURL = defaultUserImg;
  }

  final userDocRef =
      FirebaseFirestore.instance.collection("User").doc(currentUser!.uid);

  await userDocRef.set({
    'userID': userDocRef.id,
    'userName': newUser.userName,
    'email': newUser.email,
    'imageURL': newUser.imageURL,
    'password': newUser.password,
    //   'token':newUser.token
  });
}

Future<void> updateUser(
    UserModel updatedUser, UserModel currentUser, BuildContext context) async {


  if (updatedUser.imageURL == null &&
      updatedUser.email == currentUser.email &&
      updatedUser.userName == currentUser.userName) {
    showSnackBar(context, 'No Info has been updated.');
    return;
  } else {


    await auth.signInWithEmailAndPassword(
      email: currentUser.email,
      password: currentUser.password,
    );

    if (updatedUser.imageURL == null) {
      updatedUser.imageURL = currentUser.imageURL;

      editUser(updatedUser, context);
    } else {


      editUser(updatedUser, context, imgChanged: true);
    }

  }
}

Future<void> editUser(UserModel updatedUser, BuildContext context,
    {bool imgChanged = false}) async {

      await FirebaseFirestore.instance
        .collection("User")
        .doc(auth.currentUser!.uid)
        .update({
      'email': updatedUser.email,
      'userName': updatedUser.userName,
      'imageURL': updatedUser.imageURL,
    });

    showSnackBar(context, 'Your account has been\nupdated successfully.');


}

Future<String> getStorageImgURL(String? uid, File imageURL) async {
  final ref =
      FirebaseStorage.instance.ref().child("user_image").child('$uid.jpg');

  ref.putFile(imageURL);

  String newImageURL = await ref.getDownloadURL();

  return newImageURL;
}

Stream<UserModel> getUserStream() {
  final userSnapShot = FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  return userSnapShot.asyncMap((user) => UserModel.fromSnapshot(user.data()!));
}

Stream<List<UserModel>> getAllProfilesStream() {
  final profiles = FirebaseFirestore.instance.collection("User").snapshots();
  return profiles.asyncMap((event) {
    return event.docs
        .map((profile) => UserModel.fromSnapshot(profile.data()))
        .toList();
  });
}

Future<String?> getUserName(String userId) async {
  try {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();

    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('userName')) {
        String userName = data['userName'];
        print("userName: $userName");
        return userName;
      } else {
        print('userName field does not exist in the document.');
      }
    } else {
      print('Document does not exist for userId: $userId');
    }
  } catch (e) {
    print('Error retrieving userName: $e');
  }

  return null;
}
