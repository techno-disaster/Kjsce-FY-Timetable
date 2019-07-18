import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'myApp.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds:DashboardScreen(),
      title: Text('Bunk it!',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 25.0,
        color: Colors.white70
      ),),
      image: Image.asset("Assets/icon.png"),
      backgroundColor: Color(0xff191414),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 50.0,
     // onClick: ()=>print("Flutter Egypt"),
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}