import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:permission_handler/permission_handler.dart';

Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.request().isGranted) {
    // Permission granted, you can now schedule exact alarms
  } else {
    // Permission denied
  }
}

void saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', userId);

  initializeService();
}
// Function to get userId from SharedPreferences
Future<String> _getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') ?? 'default_user_id';
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Get userId from SharedPreferences
  String userId = await _getUserId();

  // Connect to the Socket.IO server
  IO.Socket socket = IO.io('https://spmps.onrender.com', <String, dynamic>{
    'transports': ['websocket'],
    'query': {'userId': userId}, // Using the fetched userId
  });

  // Listen for connection
  socket.onConnect((_) {
    service.invoke('update', {'status': 'Connected to Socket.IO server'});
    print('Connected to Socket.IO server');
  });

  // Listen for notifications
  socket.on('notification', (data) {
    print('New Notification: $data');
    service.invoke('notification', {'data': data});
  });

  // Handle disconnection
  socket.onDisconnect((_) {
    service.invoke('update', {'status': 'Disconnected from server'});
    print('Disconnected from the server');
  });

  // Keep the service alive
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('iOS background fetch executed');
  return true;
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is destroyed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(BuildContext context) async {
    print(emailController.text.trim());
    try {
      final response = await http.post(
        Uri.parse('https://spmps.onrender.com/login'), // Your custom API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 200) {
         String userId = emailController.text.trim();
        saveUserId(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in successful!')),
        );

        // Navigate to homepage
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/homepage');
      } else {
        String message;
        if (jsonResponse['status'] == 404) {
          message = 'No user found for that email.';
        } else if (response.statusCode == 401) {
          message = 'Wrong password provided.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Come onboard!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  signIn(context);
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
