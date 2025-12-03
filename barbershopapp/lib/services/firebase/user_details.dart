import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User model class
class UserDetails {
  final String? userId;
  final String? name;
  final String? email;

  UserDetails({required this.userId, required this.name, required this.email});
}

// StateNotifier to manage user details
class UserDetailsNotifier extends StateNotifier<UserDetails?> {
  UserDetailsNotifier() : super(null) {
    _listenToAuthChanges(); // Start listening to auth state changes
  }

  // Listen to Firebase authentication state changes
  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = user == null
          ? null
          : UserDetails(
              userId: user.uid, name: user.displayName, email: user.email);
    });
  }

  // Manually refresh user details (useful after profile update)
  void refreshUserDetails() {
    final user = FirebaseAuth.instance.currentUser;
    state = user == null
        ? null
        : UserDetails(
            userId: user.uid, name: user.displayName, email: user.email);
  }
}

// Provider for user details
final userDetailsProvider =
    StateNotifierProvider<UserDetailsNotifier, UserDetails?>((ref) {
  return UserDetailsNotifier();
});
