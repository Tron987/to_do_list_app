import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/landing.dart';
import 'package:todolist/loginScreen.dart';
import 'package:todolist/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Check if user has already logged in
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Timer(const Duration(seconds: 4), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Task()), (route) => false);
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Capture11.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Hero(
            tag: "logo",
            child: AspectRatio(
              aspectRatio: 1,
              child: Image(
                image: AssetImage('images/Capture11.PNG'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
