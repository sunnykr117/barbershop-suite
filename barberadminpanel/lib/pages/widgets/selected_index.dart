import 'package:flutter_riverpod/flutter_riverpod.dart';

// State Provider to track the selected index of the bottom navigation bar
final selectedIndexProvider = StateProvider<int>((ref) => 0);
