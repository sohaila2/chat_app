import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  late final String UserID = FirebaseAuth.instance.currentUser!.uid;
  late String userName;
  late String email;
  var imageURL;
  late String password;

 UserModel();

  UserModel.fromSnapshot(Map<String, dynamic> document) {
    userName = document['userName'] ?? "";
    email = document['email'] ?? "";
    imageURL = document['imageURL'] ?? "";
    password = document['password'] ?? "";
  }
}