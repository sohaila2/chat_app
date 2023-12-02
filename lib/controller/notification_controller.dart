import 'package:chat_app/model/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/user.dart';

String? mToken = " ";

Future<void> getToken(void Function(String) onTokenReceived) async {
  await FirebaseMessaging.instance.getToken().then((token) {
    mToken = token;
    print("my token is : $mToken");
    saveToken(token!);
    onTokenReceived(token);
  });
}

Future<void> saveToken(String token) async {
  UserModel userModel = UserModel();

  await FirebaseFirestore.instance
      .collection("User")
      .doc(userModel.UserID)
      .update({
    'token': token,
  });
}

Future createNotification(String title, String body) async {
  final notificationDocRef =
      FirebaseFirestore.instance.collection("notifications").doc();

  await notificationDocRef.set({
    'notificationId': notificationDocRef.id,
    'title': title,
    'body': body,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<void> deleteNotification(String notificationId) async {
  await FirebaseFirestore.instance
      .collection("notifications")
      .doc(notificationId)
      .delete();
}

Future<void> deleteAllNotifications() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('notifications').get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }

    print('All notifications deleted successfully.');
  } catch (e) {
    print('Error deleting all notifications: $e');
  }
}

Stream<List<NotificationModel>> getAllNotificationsStream() {
  final notifications =
      FirebaseFirestore.instance.collection("notifications").snapshots();
  return notifications.asyncMap((event) {
    return event.docs
        .map((notification) =>
            NotificationModel.fromSnapshot(notification.data()))
        .toList();
  });
}
