import 'package:barbershopapp/pages/login_page.dart';
import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
    SnackBarMessenger.show(context, 'SignOut Sucessfull');
  } catch (e) {
    SnackBarMessenger.show(context, 'SignOut Failed');
  }
}
