import 'package:flutter/material.dart';
import 'package:task_project/core/blocs/services/shared_prefs.dart';
import 'package:task_project/screens/HomeScreen.dart';
import 'package:task_project/screens/LoginScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      if (SharedPrefs().isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
