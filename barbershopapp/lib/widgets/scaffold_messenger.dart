import 'package:flutter/material.dart';

class SnackBarMessenger extends StatelessWidget {
  final String message;
  final bool isError; // Optional: To style error messages differently

  const SnackBarMessenger({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine background color based on isError
    Color backgroundColor = isError ? Colors.redAccent : Colors.green;

    return SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating, // Makes it float above other content
      duration: Duration(seconds: 3), // Adjust duration as needed
    );
  }

  static void show(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ));
  }
}

// Example usage within a button's onPressed:

// ElevatedButton(
//   onPressed: () {
//     // Show a success message
//     SnackBarMessenger.show(context, "Task completed successfully!");
//
//     // Show an error message
//     SnackBarMessenger.show(context, "An error occurred.", isError: true);
//   },
//   child: Text("Show SnackBar"),
// )
