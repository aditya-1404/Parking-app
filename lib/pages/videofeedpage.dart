import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'socket_service.dart'; // Import the SocketService

class VideoFeedPage extends StatefulWidget {
  @override
  _VideoFeedPageState createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  Uint8List? currentImage; // Holds the current image data

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndConnect();
  }

  // Fetch userId from SharedPreferences and connect to the socket service
  void _fetchUserIdAndConnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Fetch userId from SharedPreferences

    if (userId != null) {
      // Initialize the socket service
      SocketService socketService = SocketService();
      await socketService.initializeSocket(userId, context);  // Pass BuildContext to initializeSocket

      // Listen for the video feed data from SocketService
      socketService.onVideoFeedReceived = (Uint8List videoFeedData) {
        setState(() {
          currentImage = videoFeedData;
        });
      };
    } else {
      print("User ID not found in SharedPreferences");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make the app bar transparent
      appBar: AppBar(
        title: Text('Real-Time Video Feed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade300, Colors.purple.shade900],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80), // Space below the AppBar
            Text(
              'Live Camera Feed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: currentImage != null
                  ? Card(
                      elevation: 10,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.grey.shade200,
                          ),
                          child: Image.memory(
                            currentImage!,
                            fit: BoxFit.cover, // Maintain aspect ratio and cover box
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
            ),
            SizedBox(height: 40),
            Text(
              currentImage != null
                  ? 'Video Feed Received'
                  : 'Waiting for video feed...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
