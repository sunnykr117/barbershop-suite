import 'package:barberadminpanel/pages/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TodaysBookingsPage extends StatelessWidget {
  const TodaysBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Bookings"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('userBookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings for today.'));
          }

          final allBookings = snapshot.data!.docs;
          final today = DateTime.now();
          final todayFormatted = DateFormat('yyyy-MM-dd').format(today);

          List<DocumentSnapshot> todaysBookings = allBookings.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('selectedDateTime') && data['selectedDateTime'] != null) {
              final bookingDate = (data['selectedDateTime'] as Timestamp).toDate();
              return DateFormat('yyyy-MM-dd').format(bookingDate) == todayFormatted;
            }
            return false;
          }).toList();

          if (todaysBookings.isEmpty) {
            return const Center(child: Text('No bookings for today.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: todaysBookings.length,
            itemBuilder: (context, index) {
              final doc = todaysBookings[index];
              final data = doc.data() as Map<String, dynamic>;
              return BookingCard(
                bookingId: data['bookingId'] ?? 'N/A',
                username: data['name'] ?? 'N/A',
                email: data['email'] ?? 'N/A',
                services: List<String>.from(data['selectedServices'] ?? []),
                selectedDateTime: data['selectedDateTime'],
                timestamp: data['timestamp'],
                docRef: doc.reference,
              );
            },
          );
        },
      ),
    );
  }
}
