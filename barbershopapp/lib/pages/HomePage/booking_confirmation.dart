import 'package:barbershopapp/services/firebase/booking_upload.dart';
import 'package:barbershopapp/widgets/elevated_button.dart';
import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/riverpod/selected_services.dart'; // Adjust the import path
import 'package:intl/intl.dart'; // For formatting date & time

class BookingConfirmation extends ConsumerStatefulWidget {
  const BookingConfirmation({super.key});

  @override
  ConsumerState<BookingConfirmation> createState() =>
      _BookingConfirmationState();
}

class _BookingConfirmationState extends ConsumerState<BookingConfirmation> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Function to pick a date
  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // User can't select past dates
      lastDate: DateTime.now()
          .add(const Duration(days: 30)), // Limit to 30 days ahead
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Dark theme for date picker
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // Function to pick a time
  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // Dark theme for time picker
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  // Function to format date and time
  String getFormattedDateTime() {
    if (selectedDate == null || selectedTime == null) {
      return "Select Date & Time";
    }
    DateTime fullDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    return DateFormat('MMM dd, yyyy • hh:mm a').format(fullDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices =
        ref.watch(selectedServiceProvider)['services'] as List<String>;

    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background
      appBar: AppBar(
        title: const Text('Booking Confirmation',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[800], // Darker indigo app bar
        elevation: 0, // Remove shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch to fill width
          children: [
            // Selected Services
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[800], // Darker container
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(), // Darker shadow
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Selected Services',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[400]),
                  ),
                  const SizedBox(height: 15),
                  if (selectedServices.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedServices
                          .map(
                            (service) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Text(service,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    const Text('No services selected.',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Date and Time Selection
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Date & Time",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          getFormattedDateTime(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: Colors.white),
                            onPressed: _pickDate,
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time,
                                color: Colors.white),
                            onPressed: _pickTime,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BOOK Button
            CustomElevatedButton(
              text: 'BOOK',
              onPressed: () async {
                if (selectedDate == null || selectedTime == null) {
                  SnackBarMessenger.show(context,'Please select a date & time');
                  return;
                }

                // Convert DateTime to Firebase-compatible format
                DateTime fullDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                // Upload booking with date & time
                await bookingUpload(
                    ref, selectedServices, fullDateTime, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
