import 'dart:async';

import 'package:barbershopapp/pages/authgate.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Change 3 to your desired duration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthGate(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Change to your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/Logo.png', // Replace with your logo asset path
              width: double.infinity, // Adjust logo size
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Trim & Go', // Replace with your app name
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
