import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app/pages/mappage.dart';
import 'package:parking_app/pages/menu.dart';
import 'package:parking_app/pages/signin.dart';
import 'package:parking_app/pages/signup.dart';
import 'package:parking_app/pages/welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking_app/pages/homepage.dart';
import 'package:parking_app/pages/registervehicle.dart';
import 'package:parking_app/pages/registervehiclesuccess.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await initializeService();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.itim().fontFamily,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => WelcomePage(),
        "/signin": (context) => SignIn(),
        "/signup": (context) => SignUpScreen(),
        // "/mapscreen": (context) => MapScreen(),
        "/homepage": (context) => HomePage(
              vehicles: [],
              activeBookings: [],
            ),
        "/menu": (context) => MenuPage(),
        "/registervehicle": (context) => RegisterVehiclePage(vehicles: []),
        "/registervehiclesuccess": (context) => SuccessfulPage(vehicles: []),
      },
    );
  }
}
