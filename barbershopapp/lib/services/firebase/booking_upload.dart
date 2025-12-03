import 'dart:math';
import 'package:barbershopapp/pages/HomePage/home.dart';
import 'package:barbershopapp/services/firebase/user_details.dart';
import 'package:barbershopapp/services/riverpod/selected_services.dart';
import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Function to generate a random booking ID
String generateBookingId() {
  int randomNumber = Random().nextInt(100) + 1; // Random number (1-100)
  bool includeExtraChars =
      Random().nextBool(); // Randomly decide to add letters

  if (includeExtraChars) {
    // Generate a random letter (A-Z)
    String randomLetter = String.fromCharCode(Random().nextInt(26) + 65);
    return "TrimandGo$randomLetter$randomNumber"; // Example: TrimandGoA25
  } else {
    return "TrimandGo$randomNumber"; // Example: TrimandGo42
  }
}

// Booking upload function with date, time, and user details
Future<void> bookingUpload(WidgetRef ref, List<String> selectedServices,
    DateTime selectedDateTime, BuildContext context) async {
  try {
    // Get user details from provider
    final userDetails = ref.watch(userDetailsProvider);

    // Ensure user is actually logged in
    final currentUser = FirebaseAuth.instance.currentUser;

    if (userDetails == null ||
        currentUser == null ||
        userDetails.userId != currentUser.uid) {
      SnackBarMessenger(
          message: "Error: User is not logged in or details mismatch.");
      return;
    }

    String userId = userDetails.userId!;
    String bookingId = generateBookingId(); // Generate random booking ID

    // Create booking data map
    Map<String, dynamic> bookingData = {
      "bookingId": bookingId,
      "name": userDetails.name,
      "email": userDetails.email,
      "selectedServices": selectedServices,
      "selectedDateTime": Timestamp.fromDate(selectedDateTime),
      "timestamp": FieldValue.serverTimestamp(),
    };

    // Store booking data inside a subcollection named after the user ID
    await FirebaseFirestore.instance
        .collection('bookings') // Main collection
        .doc(userId) // Document for the specific user
        .collection('userBookings') // Subcollection for user's bookings
        .doc(bookingId) // Unique booking ID
        .set(bookingData); // Store booking data

    SnackBarMessenger(
      message: 'Booking Confirmed',
    );

    clearSelectedService(ref);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  } catch (e) {
    SnackBarMessenger(message: "Error uploading booking: $e");
  }
}
