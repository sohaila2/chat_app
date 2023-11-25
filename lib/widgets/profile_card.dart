import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: CachedNetworkImage(
                imageUrl: userModel.imageURL,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 60,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: Colors.orangeAccent,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                        userModel.userName,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
        const Divider(),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const Icon(Icons.info,
                  color: kPrimaryColor, size: 25),
              const SizedBox(width: 8.0),
              Text(
                'User Information'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text(
            "Full Name",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
           userModel.userName ,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.person,
              size: 24.0,
              color: Colors.blueGrey,
            ),
            onPressed: () {},
          ),
        ),
        ListTile(
          title: const Text(
            "Email",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            userModel.email,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.email,
              size: 24.0,
              color: Colors.blueGrey,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
