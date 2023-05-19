import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/home.dart';
import 'stripe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Color(0xFF0099FF), // Set the color of the top bar here
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Container(
          child: AnimatedSplashScreen(
            duration: 3000,
            splash: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/logo.png',
                )),
            nextScreen: HomePage(),
            splashTransition: SplashTransition.fadeTransition,
          ),
        ));
  }
}
