import 'package:barbershopapp/services/riverpod/selected_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbershopapp/pages/HomePage/home_page.dart';
import 'package:barbershopapp/pages/HomePage/bookings.dart';
import 'package:barbershopapp/pages/HomePage/profile.dart';
import 'package:barbershopapp/pages/HomePage/services.dart';
import 'package:barbershopapp/services/firebase/logout.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Trim & Go",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
              icon: const Icon(Icons.logout, color: Colors.white),
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
          HomePage(),
          Services(),
          Bookings(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        height: 60,
        backgroundColor: Colors.black,
        color: Colors.grey[900]!,
        buttonBackgroundColor: Colors.deepPurpleAccent,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list_alt, size: 30, color: Colors.white),
          Icon(Icons.event_available, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
          pageController.jumpToPage(index);
        },
      ),
    );
  }
}
