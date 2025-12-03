// Define the selected service map type
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SelectedService = Map<String, dynamic>;

// Create a StateProvider for the selected service
final selectedServiceProvider = StateProvider<SelectedService>((ref) {
  return {
    'services': <String>[], // Initialize with an empty list of services
  };
});

void clearSelectedService(WidgetRef ref) {
  ref.read(selectedServiceProvider.notifier).state = {
    'services': <String>[],
  };
}
