import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final bool _isUpdating = false;
  bool _changePassword = false; // Toggle for showing password fields

  User? get user => _auth.currentUser;

  // Function to update password with re-authentication
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        SnackBarMessenger.show(context,"User not found. Please log in again.");
        return;
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      SnackBarMessenger(message: "Password changed successfully!",);
      _currentPasswordController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _changePassword = false; // Hide fields after update
      });
    } catch (e) {
      SnackBarMessenger.show(context, "Task completed successfully!");
    }
  }

  // void showSnackbar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message, style: const TextStyle(color: Colors.white)),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("User Details",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Divider(color: Colors.white),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(user?.displayName ?? "N/A",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    subtitle: const Text("Name",
                        style: TextStyle(color: Colors.white70)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.white),
                    title: Text(user?.email ?? "N/A",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    subtitle: const Text("Email",
                        style: TextStyle(color: Colors.white70)),
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.verified_user, color: Colors.white),
                    title: Text(user?.uid ?? "N/A",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white)),
                    subtitle: const Text("User ID",
                        style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Toggle Switch for Password Change
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Change Password",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Enable password change",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Switch(
                        value: _changePassword,
                        onChanged: (value) =>
                            setState(() => _changePassword = value),
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                  if (_changePassword) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Current Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "New Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty ||
                              _currentPasswordController.text.isEmpty) {
                            SnackBarMessenger.show(context,"Please fill all fields before updating.",);
                            return;
                          }
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            SnackBarMessenger.show(context,"Passwords do not match!");
                            return;
                          }
                          changePassword(_currentPasswordController.text,
                              _passwordController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isUpdating
                            ? const CircularProgressIndicator(
                                color: Colors.black)
                            : const Text(
                                "Update Password",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
