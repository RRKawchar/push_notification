import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_demo/services/api_service.dart';

import '../services/notification_service.dart';
import 'package:http/http.dart'as http;
class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  bool _isSwitch = false;

  var deviceTokenToSendPushNotification = '';

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    //print("Token Value ::==$deviceTokenToSendPushNotification");
  }

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("rrk100");
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("Test Notification check message $message");

        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    super.initState();
  }

 ApiService apiService=ApiService();

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Switch.adaptive(
              activeColor: Colors.red,
                activeTrackColor: Colors.green,
                value: _isSwitch,
                onChanged: (value) {
                  setState(() {
                    _isSwitch = value;
                  });

                  if(_isSwitch){
                    // print("This is : $_isSwitch");
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return const AlertDialog(
                    //       content: Text('Switch is turned on'),
                    //     );
                    //   },
                    // );
                    apiService.sendDeviceToken(deviceTokenToSendPushNotification);
                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Text('Switch is turned off'),
                        );
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
