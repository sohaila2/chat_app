

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import 'edit_user_screen.dart';

class UserSettingsScreen extends StatelessWidget {
  final UserModel? userModel;
  const UserSettingsScreen(this.userModel, {Key? key}) : super(key: key);

  static String id = 'UserSettingsScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'App Settings',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: size.height * 0.10,
      ),
      body: userModel != null
          ? Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             // SizedBox(height: size.height * 0.04),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  fixedSize: const Size(200, 55),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserScreen(userModel!)),
                  );
                },
                icon: const Icon(Icons.mode_edit_rounded,
                    color: Colors.white),
                label: const Text(
                  "Edit Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      )
          : const Center(
        child: Text(
          "Bad Connection, Couldn't load user data.",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
