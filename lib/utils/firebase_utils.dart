import 'dart:io';
import 'dart:math';
import 'package:doc_upload/global/app_helper.dart';
import 'package:doc_upload/utils/routes/routes_name.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseUtils {
  static String fcmToken = "";
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setupFirebaseMessaging(BuildContext context) async {
    await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    debugPrint("FCM Token ===> $fcmToken");
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      fcmToken = token;
      debugPrint("FCM Token Refresh ===> $fcmToken");
    }).onError((err) {
      debugPrint("Firebase Token Refresh Error ===> $err");
    });
    // ignore: use_build_context_synchronously
    listenPushMessage(context);
  }

   void listenPushMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint("Message Title ${message.notification!.title}");
      debugPrint('Message data: ${message.notification!.body.toString()}');
      debugPrint(message.data.toString());
      debugPrint(message.data['type']);
      debugPrint(message.data['docId']);

      if(Platform.isAndroid){
        initLocalNotification(context, message);
        showNotification(message);
      }
      else{
         showNotification(message);
      }
    });
  }

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(Random.secure().nextInt(10000).toString(),
            "High Importance Notifications",
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: "Your Channel Description",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message){
    if(message.data['type'] == 'document'){
      debugPrint("Type :" +message.data['type']);
       debugPrint("id :" +message.data['docId']);
      Navigator.pushNamed(context, RoutesName.notificationView,arguments: {
        'type':message.data['type'],
        'id':message.data['docId'],
        'docLink':docUrl,
        'doctype':docType
      });
    }
  }

  Future<void>  setupInteractMessage(BuildContext context,)async{
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }
    // when app is in background

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
     });
  }
  
}