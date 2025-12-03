import 'package:barberadminpanel/pages/homepage/todays_bookings.dart';
import 'package:barberadminpanel/pages/homepage/previous_bookings.dart';
import 'package:barberadminpanel/pages/profile_page.dart';
import 'package:barberadminpanel/pages/services/firebase/logout.dart';
import 'package:barberadminpanel/pages/homepage/upcoming_bookings.dart';
import 'package:barberadminpanel/pages/widgets/selected_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(selectedIndexProvider);
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trim & Go",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        toolbarHeight: 50,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () async {
                await logout(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        children: const [
          TodaysBookingsPage(),
          UpcomingBookings(),
          PreviousBooking(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              blurRadius: 10,
              spreadRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            gap: 8,
            backgroundColor: Colors.black87,
            color: Colors.white,
            activeColor: Colors.orange,
            tabBackgroundColor: Colors.white10,
            padding: const EdgeInsets.all(10),
            tabs: const [
              GButton(
                icon: Icons.today,
                text: 'Today',
              ),
              GButton(
                icon: Icons.upcoming,
                text: 'Upcoming',
              ),
              GButton(
                icon: Icons.history,
                text: 'History',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              ref.read(selectedIndexProvider.notifier).state = index;
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ),
    );
  }
}
