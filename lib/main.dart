import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/guest_name_screen.dart';

void main() {
  runApp(const TicketDigitalApp());
}

class TicketDigitalApp extends StatelessWidget {
  const TicketDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Digital Wedding',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const GuestNameScreen(),
    );
  }
}
