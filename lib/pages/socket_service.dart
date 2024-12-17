import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parking_app/pages/videofeedpage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'paymentpage.dart'; // Import your PaymentPage
import 'package:parking_app/global.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Callback function for video feed
  Function(Uint8List)? onVideoFeedReceived;
  // Callback function for notifications
  Function(String title, String body)? onNotificationReceived;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  // Initialize the socket connection and notifications
  Future<void> initializeSocket(String userId, BuildContext context) async {
    // Initialize notifications
    await _initializeNotifications(context);

    socket = IO.io('https://spmps.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'userId': userId},
    });

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    // Listen for 'videofeed' event and pass the image data to the callback
    socket.on('videofeed', (data) {
      var json_data = jsonDecode(data);
      var img_d = json_data['image'];
      print(img_d);
      try {
        String base64Data = img_d.replaceFirst(RegExp(r"^data:image\/\w+;base64,"), "");
        print(base64Data);
        Uint8List videoFeed = base64Decode(base64Data);
        if (onVideoFeedReceived != null) {
          onVideoFeedReceived!(videoFeed); // Trigger the callback with the decoded image
        }
      } catch (e) {
        print('Error parsing video feed data: $e');
      }
    });

    // Listen for 'notification' event and pass the data to the callback
    socket.on('notification', (data) async {
      try {
        var notificationData = jsonDecode(data);
        String title = notificationData['title'];
        String body = notificationData['body'];
        double amt = (notificationData['amt'] as num).toDouble();

        if (onNotificationReceived != null) {
          onNotificationReceived!(title, body); // Trigger the callback for notifications
        }

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'Channel Name',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              styleInformation: BigTextStyleInformation(
                body,
                contentTitle: title,
              ),
            ),
          ),
          payload: jsonEncode({'title': title, 'body': body,'amt':amt}),  // Add payload
        );
      } catch (e) {
        print('Error parsing notification data: $e');
      }
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server');
    });
  }

  // Initialize the Flutter Local Notifications plugin and handle tap
  Future<void> _initializeNotifications(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle the notification response (tap)
        String? payload = response.payload;
        if (payload != null) {
          var notificationData = jsonDecode(payload);
          var amt=notificationData['amt'];
          String title = notificationData['title'];
          if (title == "Title") {
            // Navigate to the PaymentPage if the notification is "Session ended"
            print(context);
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => PaymentPage(amountToPay: amt,)),
            );
          }
          if (title == "Session started") {
            // Navigate to the PaymentPage if the notification is "Session ended"
            print(context);
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => VideoFeedPage()),
            );
          }
        }
      },
    );

    if (initialized == null || !initialized) {
      print('Failed to initialize notifications');
    } else {
      print('Notifications initialized');
    }
  }

  // Stop the socket connection
  Future<void> stopSocket() async {
    if (socket.connected) {
      await socket.disconnect();
      print('Socket disconnected');
    }
  }

  // Method to register the callback function for video feed
  void setOnVideoFeedReceived(Function(Uint8List) callback) {
    onVideoFeedReceived = callback;
  }

  // Method to register the callback function for notifications
  void setOnNotificationReceived(Function(String, String) callback) {
    onNotificationReceived = callback;
  }
}
