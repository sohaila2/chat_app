import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
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
  });
}

Future<void> updateUser(UserModel updatedUser, UserModel currentUser,
    BuildContext context) async {
  // showLoadingIndicator(context);
  print("enter update function");

  if (updatedUser.imageURL == null &&
      updatedUser.email == currentUser.email &&
      updatedUser.userName == currentUser.userName) {
    showSnackBar(context, 'No Info has been updated.');
    return;
  }
  else {
    print("hello1");

    // Authentication Sign in selected Driver
    await auth.signInWithEmailAndPassword(
      email: currentUser.email,
      password: currentUser.password,
    );

    if (updatedUser.imageURL == null) {
      updatedUser.imageURL = currentUser.imageURL;
      print("hello2");

      editUser(updatedUser, context);
    } else {
      print("hello3");

      editUser(updatedUser, context, imgChanged: true);
    }
    print("exit update function");
  }



}

Future<void> editUser(UserModel updatedUser, BuildContext context,
    {bool imgChanged = false}) async {


  try {
    // Update Email in FirebaseAuth
    print("enter edit function");

    if (updatedUser.email != auth.currentUser!.email) {
      await auth.currentUser!.updateEmail(updatedUser.email);
    }

    if (imgChanged) {
      // Update User Image in FirebaseStorage
      updatedUser.imageURL =
      await getStorageImgURL(auth.currentUser!.uid, updatedUser.imageURL);
    }
    print("rightttt");
    // Update Email, PhoneNumber, UserName, and ImageUrl in FirebaseStore + making the time of update
    await FirebaseFirestore.instance
        .collection("User")
        .doc(auth.currentUser!.uid)
        .update({
      'email': updatedUser.email,
      'userName': updatedUser.userName,
      'imageURL': updatedUser.imageURL,
    });
    print("exit edit function");

    showSnackBar(context, 'Your account has been\nupdated successfully.');
    print("finish");

  } catch (e) {
    showSnackBar(context, "Couldn't update account, Please try again.");
    if (kDebugMode) {
      print("\n\n${auth.currentUser!.uid}\n\n");
      print(e);
    }
    return;
  }
}


Future<String> getStorageImgURL(String? uid, File imageURL) async {
  final ref =
  FirebaseStorage.instance.ref().child("user_image").child('$uid.jpg');

  await ref.putFile(imageURL);

  String newImageURL = await ref.getDownloadURL();

  return newImageURL;
}
Stream<UserModel> getUserStream() {
  final userSnapShot = FirebaseFirestore.instance
      .collection("User")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  return userSnapShot
      .asyncMap((user) => UserModel.fromSnapshot(user.data()!));
}

Stream<List<UserModel>> getAllProfilesStream() {
  final userID = FirebaseAuth.instance.currentUser;

  final profiles = FirebaseFirestore.instance
      .collection("User")
      .snapshots();

  return profiles.asyncMap((event) {
    return event.docs
        .map((profile) => UserModel.fromSnapshot(profile.data()))
        .toList();
  });
}
