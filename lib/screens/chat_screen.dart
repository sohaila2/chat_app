import 'package:chat_app/constants.dart';
import 'package:chat_app/controller/user_controller.dart';
import 'package:chat_app/cubits/chat/chat_cubit.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/screens/user_profile_screen.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/notification_controller.dart';

class ChatScreen extends StatelessWidget {
  static String id = 'ChatScreen';
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  final userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments as String;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text(" Chat App"),
          ],
        ),
        toolbarHeight: size.height * 0.10,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
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
                      return messagesList[index].id == email
                          ? ChatBubble(message: messagesList[index])
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
              onSubmitted: (data) async {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: data, email: email);
                controller.clear();
                _controller.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );

                String? userName = await getUserName(userModel.UserID);

                await getToken((token) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendPushMessage(token, data, userName!);
                });
              },
              decoration: InputDecoration(
                  hintText: 'Send Message',
                  suffixIcon: const Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
