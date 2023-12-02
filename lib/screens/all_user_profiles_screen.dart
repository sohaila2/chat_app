

import 'package:chat_app/constants.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/widgets/user_profile_card.dart';
import 'package:flutter/material.dart';


class AllProfilesScreen extends StatelessWidget {
  const AllProfilesScreen({Key? key}) : super(key: key);

  static String id = 'AllProfilesScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'All Profiles',
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

      body: Container(

        child: StreamBuilder<List<UserModel>>(
            stream: getAllProfilesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Bad Connection, Couldn't load user data\n${snapshot.error}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              List<UserModel> allProfiles = snapshot.data!;

              if (allProfiles.isEmpty) {
                // handle empty state
                return const Center(
                  child: Text(
                    "You didn't make any notifications with us yet.",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: allProfiles.length,
                  itemBuilder: (context, index) {
                    UserModel profile = allProfiles[index];
                    return UserProfileCard(size: size, user: profile);
                  });
            }),
      ),
    );
  }
}
