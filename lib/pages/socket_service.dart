import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  Future<void> initializeSocket(String userId) async {
    // Initialize notifications
    await _initializeNotifications();

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
        );
      } catch (e) {
        print('Error parsing notification data: $e');
      }
    });

    socket.onDisconnect((_) {
      print('Disconnected from the server');
    });
  }

  // Initialize the Flutter Local Notifications plugin
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
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
