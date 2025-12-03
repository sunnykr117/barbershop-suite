import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> login(String email, String password, Widget nextpage,
    BuildContext context) async {
  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      // Add navigation to your home screen or next page here
      // Delay navigation for better user experience
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => nextpage,
          ),
        );
        // Login successful
        SnackBarMessenger.show(context, 'Login successful!');
      });
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      String errorMessage = 'Login failed.';
      bool isError = true;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Firebase Auth error: ${e.code}, ${e.message}';
      }

      SnackBarMessenger.show(context, errorMessage, isError: isError);
    } catch (e) {
      // Handle other exceptions
      SnackBarMessenger.show(context, 'Error during login: $e', isError: true);
    }
  } else {
    // Handle empty fields
    SnackBarMessenger.show(context, 'Please fill in all fields.',
        isError: true);
  }
}
