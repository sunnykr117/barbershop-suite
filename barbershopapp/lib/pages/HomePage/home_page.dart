import 'package:barbershopapp/services/firebase/fetch_and_delete_booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime nextWeek = now.add(const Duration(days: 7));
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.deepPurple, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome,',
                          style: TextStyle(fontSize: 20, color: Colors.white70),
                        ),
                        Text(
                          user?.displayName ?? "Guest",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(now),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Ongoing Services",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Service List Section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getUserBookingsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No bookings found.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  );
                }

                final bookingList = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data.containsKey('selectedDateTime') && data['selectedDateTime'] != null) {
                    DateTime bookingDate = (data['selectedDateTime'] as Timestamp).toDate();
                    return bookingDate.isAfter(now) && bookingDate.isBefore(nextWeek);
                  }
                  return false;
                }).toList();

                if (bookingList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No bookings in the next 7 days.",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    final booking = bookingList[index];
                    final data = booking.data() as Map<String, dynamic>;

                    // Extract and format booking time
                    String formattedDate = "Not set";
                    if (data.containsKey('selectedDateTime') && data['selectedDateTime'] != null) {
                      DateTime bookingDate = (data['selectedDateTime'] as Timestamp).toDate();
                      formattedDate = DateFormat('EEEE, MMM dd, yyyy - hh:mm a').format(bookingDate);
                    }

                    // Extract services
                    String services = "No services selected";
                    if (data.containsKey('selectedServices') && data['selectedServices'] is List) {
                      services = (data['selectedServices'] as List).join(', ');
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurpleAccent.withValues(),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Services: $services",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Time: $formattedDate",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
