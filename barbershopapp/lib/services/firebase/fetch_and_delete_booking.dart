// Function to delete a booking
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Stream to listen for real-time updates
Stream<QuerySnapshot> getUserBookingsStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Stream.empty();
  }
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(user.uid)
      .collection('userBookings')
      .orderBy('timestamp', descending: true) // Show latest bookings first
      .snapshots();
}

Future<void> deleteBooking(String bookingId) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(user.uid)
        .collection('userBookings')
        .doc(bookingId)
        .delete();

    print("Booking deleted: $bookingId");
  } catch (e) {
    print("Error deleting booking: $e");
  }
}
