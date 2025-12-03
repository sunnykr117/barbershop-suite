import 'package:barbershopapp/pages/HomePage/booking_confirmation.dart';
import 'package:barbershopapp/services/riverpod/selected_services.dart';
import 'package:barbershopapp/widgets/scaffold_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Services extends ConsumerStatefulWidget {
  const Services({super.key});

  @override
  ConsumerState<Services> createState() => _ServicesState();
}

class _ServicesState extends ConsumerState<Services> {
  final List<Map<String, dynamic>> services = [
    {'name': 'Hair Cutting', 'icon': Icons.content_cut},
    {'name': 'Shaving', 'icon': Icons.face},
    {'name': 'Massage', 'icon': Icons.spa},
    {'name': 'Spa', 'icon': Icons.bathtub},
    {'name': 'Beard Trim', 'icon': Icons.content_cut_outlined},
    {'name': 'Hair Coloring', 'icon': Icons.format_color_fill},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedServices =
        ref.watch(selectedServiceProvider)['services'] as List<String>;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCard(
                      service['name'], service['icon'], selectedServices);
                },
              ),
            ),
            // SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedServices.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirmation(),
                    ),
                  );
                } else {
                  SnackBarMessenger.show(context, 'Please select at least one service');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              ),
              child: Text("Book Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      String serviceName, IconData icon, List<String> selectedServices) {
    final isSelected = selectedServices.contains(serviceName);

    return GestureDetector(
      onTap: () {
        final currentServices =
            ref.read(selectedServiceProvider)['services'] as List<String>;
        if (currentServices.contains(serviceName)) {
          currentServices.remove(serviceName);
        } else {
          currentServices.add(serviceName);
        }
        ref.read(selectedServiceProvider.notifier).update(
              (state) => {
                ...state,
                'services': currentServices,
              },
            );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.deepPurple, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey[900]!, Colors.grey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.deepPurpleAccent.withValues() : Colors.black26,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.grey[400]),
            SizedBox(height: 8),
            Text(
              serviceName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
