

import 'package:chat_app/controller/notification_controller.dart';
import 'package:chat_app/model/notification.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static String id = 'NotificationScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'All Notifications',
          style: TextStyle(
            fontSize: 20,
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
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAllNotifications();
            },
          ),
        ],
      ),

      body: Container(
        child: StreamBuilder<List<NotificationModel>>(
            stream: getAllNotificationsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Bad Connection, Couldn't load notification data\n${snapshot.error}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              List<NotificationModel> allNotifications = snapshot.data!;

              if (allNotifications.isEmpty) {
                // handle empty state
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(
                    child: Text(
                      "You don't have any notification yet.",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: allNotifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, top: 8, bottom: 8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Title : \n${allNotifications[index].title}' ,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: kPrimaryColor
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Body : \n${allNotifications[index].body}',
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: kPrimaryColor
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Date : \n${allNotifications[index].timestamp}',
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: kPrimaryColor
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                  ],
                                                ),
                                              )
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(right: 16, top: 30),
                                              child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  deleteNotification(allNotifications[index].notificationId);

                                                },
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                  });
            }),
      ),
    );
  }
}

