import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/all_user_profiles_screen.dart';
import 'package:flutter/material.dart';
import '../controller/user_controller.dart';
import '../model/user.dart';
import '../widgets/profile_card.dart';
import 'user_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String id = 'ProfileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  late UserModel userModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'User Profile',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSettingsScreen(userModel)));
            },
            iconSize: 30,
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: size.height * .085,
            right: size.width * .01,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AllProfilesScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(130, 50),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Colors.white),
                  SizedBox(width: 8),
                  Text('All Profiles',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
            body: Container(
              child: StreamBuilder<UserModel>(
                  stream: getUserStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Bad Connection, Couldn't load user data.\n${snapshot.error}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    userModel = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView(
                        children: <Widget>[
                          ProfileCard(userModel: userModel),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}
