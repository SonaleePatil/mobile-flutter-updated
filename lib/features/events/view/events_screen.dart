import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: const EventsTab(),
    );
  }
}

