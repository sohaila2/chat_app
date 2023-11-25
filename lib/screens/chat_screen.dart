import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat/chat_cubit.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/message.dart';

class ChatScreen extends StatelessWidget {

  static String id = 'ChatScreen';
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    var email  = ModalRoute.of(context)!.settings.arguments as String;
    print(email);
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogo,
              height: 50,
            ),
            Text(" Chat App"),
          ],
        ),
        toolbarHeight: size.height * 0.10,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.id);   },
            iconSize: 30,
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email ?
                      ChatBubble(
                          message: messagesList[index])
                          : ChatBubbleForAnotherUser(
                          message: messagesList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: data, email: email);
                controller.clear();
                _controller.animateTo(
                  0,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              },
              decoration: InputDecoration(
                  hintText: 'Send Message',
                  suffixIcon: Icon(Icons.send,
                    color: kPrimaryColor,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      )
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}