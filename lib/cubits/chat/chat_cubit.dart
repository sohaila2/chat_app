import 'package:bloc/bloc.dart';
import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../controller/notification_controller.dart';
import '../../model/user.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  late UserModel userModel = UserModel();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  List<Message> messagesList = [];
  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
      print("hello");

      print(email);
    } on Exception {
//ToDo
    }
  }

  void sendPushMessage(String token, String msg, String userName) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAxV2438M:APA91bFB2r2m_UR_GTRSdeUUVZ5yvuPv3owEdPvk4ww_HSq_HuZf8UMk9lLxnR0dgwwgIsorsACca1Sy8JyNi90ojJsM6iIwfjQMi38EN3-9dRtItAiCvR14P6-WXvTPlsK-62v1C-q9'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': "FLUTTER_NOTIFICATION_CLICK",
            'status': 'done',
            'body': msg,
            'title': 'have a message'
          },
          'notification': <String, dynamic>{
            'title': userName,
            'body': msg,
          },
          'to': 'cDGhUuE5RvyWzM1iOT6D6h:APA91bExL1zwkiBMnCrxTyyg6lSMcS1iAHVEGjNy-UE-RaoippQUXNSnz5g1743qWfNIboNsiCSbW9fAwtvtRNTccJGqQzBhVg7J47G2DIGI_7vzy7wkwxYEtTGT1ILxk1gPqZrpve2C',
        }),
      );
      createNotification(userName, msg);
      print('Notification Data: ${jsonDecode(response.body)}');
      emit(ChatNotification());
      if (response.statusCode == 200) {
        print('Notification sent successfully.');
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
