import 'package:barberadminpanel/pages/admin_login.dart';
import 'package:barberadminpanel/pages/widgets/scaffold_messenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signup(String name, String email, String password,
    String confirmpassword, String collection, BuildContext context) async {
  if (name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmpassword.isNotEmpty) {
    if (password == confirmpassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          await user.updateDisplayName(name);

          await FirebaseFirestore.instance
              .collection(collection)
              .doc(user.uid)
              .set({
            'name': name,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Use the static show method of SnackBarMessenger
          SnackBarMessenger.show(context, 'User signed up successfully!');

          // Delay navigation for better user experience
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminLoginPage(),
              ),
            );
          });
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Signup failed.';
        bool isError = true;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = 'Firebase Auth error: ${e.code}, ${e.message}';
        }
        // Use the static show method of SnackBarMessenger
        SnackBarMessenger.show(context, errorMessage, isError: isError);
      } catch (e) {
        // Use the static show method of SnackBarMessenger
        SnackBarMessenger.show(context, 'Error during signup: $e',
            isError: true);
      }
    } else {
      // Use the static show method of SnackBarMessenger
      SnackBarMessenger.show(context, "Passwords do not match.", isError: true);
    }
  } else {
    // Use the static show method of SnackBarMessenger
    SnackBarMessenger.show(context, 'Please fill in all fields.',
        isError: true);
  }
}
