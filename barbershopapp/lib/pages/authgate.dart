import 'package:barbershopapp/pages/HomePage/home.dart';
import 'package:barbershopapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Added scaffold for better practice.
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator while checking auth
          }
          if (snapshot.hasData) {
            return const Home();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
