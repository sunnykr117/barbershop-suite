import 'package:barberadminpanel/pages/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UpcomingBookings extends StatelessWidget {
  const UpcomingBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('userBookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final allBookings = snapshot.data!.docs;
          final today = DateTime.now();
          final todayFormatted = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(today)); //convert to DateTime

          List<DocumentSnapshot> upcomingBookings = [];

          for (var doc in allBookings) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('selectedDateTime') &&
                data['selectedDateTime'] != null) {
              final bookingDate =
                  (data['selectedDateTime'] as Timestamp).toDate();
              final bookingFormatted = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(bookingDate)); //convert to DateTime
              if (bookingFormatted.isAtSameMomentAs(todayFormatted) || bookingFormatted.isAfter(todayFormatted)) { // Use DateTime comparison methods
                upcomingBookings.add(doc);
              }
            }
          }

          // Sort the upcoming bookings by date and time
          upcomingBookings.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aDateTime = (aData['selectedDateTime'] as Timestamp).toDate();
            final bDateTime = (bData['selectedDateTime'] as Timestamp).toDate();
            return aDateTime.compareTo(bDateTime);
          });

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (upcomingBookings.isNotEmpty) ...[
                const Text(
                  "Upcoming Bookings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...upcomingBookings.map((doc) {
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
                }),
              ],
            ],
          );
        },
      ),
    );
  }
}
