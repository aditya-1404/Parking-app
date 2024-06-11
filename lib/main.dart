import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:parking_app/pages/mappage.dart";
import "package:parking_app/pages/signup.dart";
import "package:parking_app/pages/welcomepage.dart";
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme:ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.itim().fontFamily,
      ),
      initialRoute: "/",
      routes:{
        "/":(context)=>WelcomePage(),
        "/signup":(context)=>SignUpScreen(),
        "/mapscreen":(context)=>MapScreen()
      }
    );
  }
}