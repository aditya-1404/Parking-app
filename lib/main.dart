import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app/pages/bookings.dart';
import 'package:parking_app/pages/signin.dart';
import 'package:parking_app/pages/signup.dart';
import 'package:parking_app/pages/welcomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking_app/pages/homepage.dart';
import 'package:parking_app/pages/registervehicle.dart';
import 'package:parking_app/pages/registervehiclesuccess.dart';
import 'package:parking_app/pages/vehicles.dart';
import 'package:parking_app/pages/paymentpage.dart';
import 'global.dart';

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
      navigatorKey: navigatorKey,
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
        // "/homepage": (context) => PaymentApp(),
        "/homepage": (context) => HomePage(
              activeBookings: [],
            ),
        "/registervehicle": (context) => RegisterVehiclePage(vehicles: []),
        "/registervehiclesuccess": (context) => SuccessfulPage(vehicles: []),
        "/vehicles": (context) => VehiclesPage(),
        "bookings": (context) => BookingsPage(),
        
      },
    );
  }
}
