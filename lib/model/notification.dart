import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationModel{

  late String notificationId;
  late String title;
  late String body;
  late DateTime timestamp;
  NotificationModel();

  NotificationModel.fromSnapshot(Map<String, dynamic> document) {

    notificationId = document['notificationId'] ?? "";
    title = document['title'] ?? "";
    body = document['body'] ?? "";
    timestamp = (document['timestamp'] as Timestamp).toDate();
  }
}