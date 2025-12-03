import 'package:barbershopapp/services/firebase/fetch_and_delete_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bookings extends StatelessWidget {
  const Bookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No bookings found.", style: TextStyle(fontSize: 16, color: Colors.white)),
            );
          }

          final bookingList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookingList.length,
            itemBuilder: (context, index) {
              final booking = bookingList[index];
              final data = booking.data() as Map<String, dynamic>;

              String formattedDate = "Not set";
              if (data.containsKey('selectedDateTime') && data['selectedDateTime'] != null) {
                formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(
                  (data['selectedDateTime'] as Timestamp).toDate(),
                );
              }

              return GestureDetector(
                onTap: () {},
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Services: ${data['selectedServices'].join(', ')}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => deleteBooking(booking.id),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Selected Date: $formattedDate",
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Booking ID: ${booking.id}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
