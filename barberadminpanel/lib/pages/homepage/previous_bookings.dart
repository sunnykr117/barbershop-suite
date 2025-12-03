import 'package:barberadminpanel/pages/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PreviousBooking extends StatelessWidget {
  const PreviousBooking({super.key});

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
          final todayFormatted = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(today));

          List<DocumentSnapshot> previousBookings = [];

          for (var doc in allBookings) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('selectedDateTime') &&
                data['selectedDateTime'] != null) {
              final bookingDate =
                  (data['selectedDateTime'] as Timestamp).toDate();
              final bookingFormatted = DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(bookingDate));
              if (bookingFormatted.isBefore(todayFormatted)) { // Only get bookings before today.
                previousBookings.add(doc);
              }
            }
          }

          // Sort the previous bookings by date and time, descending
          previousBookings.sort((b, a) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aDateTime = (aData['selectedDateTime'] as Timestamp).toDate();
            final bDateTime = (bData['selectedDateTime'] as Timestamp).toDate();
            return aDateTime.compareTo(bDateTime);
          });

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (previousBookings.isNotEmpty) ...[
                const Text(
                  "Previous Bookings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...previousBookings.map((doc) {
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
