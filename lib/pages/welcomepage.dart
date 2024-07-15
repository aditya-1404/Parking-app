import "package:flutter/material.dart";
import "package:parking_app/pages/signin.dart";

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomePage after 2 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 160,
          ),
          Center(
              child: Text(
            "Welcome",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 50,
          ),
          Image.asset("assets/images/p1.png"),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "Smart Parking System",
            style: TextStyle(fontSize: 18),
          ))
        ],
      ),
    );
  }
}
