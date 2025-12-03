import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchAdminDetails();
  }

  Future<void> fetchAdminDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String adminUid = user.uid;

        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(adminUid)
            .get();

        if (adminDoc.exists) {
          setState(() {
            name = adminDoc['name'] ?? "No Name";
            email = adminDoc['email'] ?? "No Email";
          });
        } else {
          setState(() {
            name = "Admin Not Found";
            email = "";
          });
        }
      } else {
        setState(() {
          name = "Not Logged In";
          email = "";
        });
      }
    } catch (e) {
      setState(() {
        name = "Error fetching data";
        email = e.toString();
      });
    }
  }

  // Function to show a dialog and change password with current password verification
  Future<void> changePasswordDialog() async {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (currentPassword.isNotEmpty &&
                    newPassword.isNotEmpty &&
                    confirmPassword.isNotEmpty) {
                  if (newPassword == confirmPassword) {
                    await verifyCurrentPasswordAndUpdatePassword(
                      currentPassword,
                      newPassword,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("New password and confirm password do not match!"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }

  // Function to verify the current password and update the password
  Future<void> verifyCurrentPasswordAndUpdatePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Re-authenticate user using the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );

      await user?.reauthenticateWithCredential(credential);

      // If reauthentication is successful, update the password
      await user?.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 80, color: Colors.blue),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: changePasswordDialog,
                  child: const Text("Change Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
