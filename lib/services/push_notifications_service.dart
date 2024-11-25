import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsService {
  // create instance of FirebaseMessaging
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // create instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // create NotificationDetails
  static late NotificationDetails notificationDetails;

  /*
   * Request permission
   */
  static Future<void> notificationRequestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  /*
   * Get device token (push token)
   */
  static Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();
    log('Device token: $token');
    Constants.DEVICE_TOKEN = token;
    return token;
  }

  /*
   * Handle foreground mode message
   */
  static void handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      display(message);
      // log('Handling a foreground message: ${message.messageId}');
      // log('Message data: ${message.data}');
      // log('Message notification: ${message.notification?.title}');
      // log('Message notification: ${message.notification?.body}');

    });
  }

  /*
   * Set up notification interface
   */
  static void notificationSetUpInterface() {
    // initialize setting for Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // initialize setting for ios
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // create initialize setting object
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings
    );

    _notificationsPlugin.initialize(initializationSettings);

    // create notification details for Android
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('high-channel', 'high channel',
            channelDescription:
                'This channel is used for important notification channel',
            playSound: true,
            priority: Priority.high,
            importance: Importance.high);

    // create notification details for IOS
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
        );

    // create NotificationDetails
    notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails
    );
  }

  /*
  * Display the notification in device
  */
  static Future<void> display(RemoteMessage message) async {
    // To display the notification in device
    try {
      // get message
      Map<String, dynamic> messageData = jsonDecode(message.data['default']);
      String title = messageData['title'] ?? '';
      String body = messageData['body'] ?? '';
      //
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // NotificationDetails notificationDetails = NotificationDetails(
      //   android: AndroidNotificationDetails("Channel Id", "Main Channel",
      //       groupKey: "gfg",
      //       color: Colors.green,
      //       importance: Importance.max,
      //       playSound: true,
      //       priority: Priority.high),
      // );
      await _notificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: message.data['route'],
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
