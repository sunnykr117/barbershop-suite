// booking_card.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String username;
  final String email;
  final List<String> services;
  final DateTime? selectedDateTime;
  final DateTime? timestamp;
  final DocumentReference docRef;

  BookingCard({
    super.key,
    required this.bookingId,
    required this.username,
    required this.email,
    required this.services,
    required dynamic selectedDateTime,
    required dynamic timestamp,
    required this.docRef,
  })  : selectedDateTime = _convertTimestamp(selectedDateTime),
        timestamp = _convertTimestamp(timestamp);

  static DateTime? _convertTimestamp(dynamic timestampData) {
    if (timestampData == null) return null;
    if (timestampData is Timestamp) {
      return timestampData.toDate();
    } else if (timestampData is String) {
      try {
        return DateTime.parse(timestampData);
      } catch (e) {
        print('Error parsing date string: $timestampData');
        return null;
      }
    } else {
      print('Unexpected timestamp type: ${timestampData.runtimeType}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('selectedDateTime: $selectedDateTime');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              services.join(', '),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.perm_identity, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Text('Booking ID: $bookingId',
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Text('Email: $email',
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Date: ${selectedDateTime != null ? DateFormat('dd MMM yyyy').format(selectedDateTime!) : 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Time: ${selectedDateTime != null ? DateFormat('hh:mm a').format(selectedDateTime!) : 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.history, size: 18, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Timestamp: ${timestamp != null ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp!) : 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => _deleteBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                ),
                child: const Icon(
                  Icons.delete,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteBooking(BuildContext context) {
    docRef.delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted successfully.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete booking: $error')),
      );
    });
  }
}
