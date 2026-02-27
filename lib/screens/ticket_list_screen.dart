import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../models/ticket.dart';
import '../widgets/ticket_card.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late List<Ticket> _tickets;

  @override
  void initState() {
    super.initState();
    _tickets = _demoTickets();
  }

  List<Ticket> _demoTickets() {
    final now = DateTime.now();
    return [
      Ticket(
        id: '101',
        title: 'Login page not loading on mobile',
        description: 'Users report that the login page shows a blank screen on iOS Safari.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        createdAt: now.subtract(const Duration(hours: 2)),
        assignee: 'John',
      ),
      Ticket(
        id: '102',
        title: 'Digital ticket QR code not scanning',
        description: 'Some ticket QR codes are not recognized at the gate scanner.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.critical,
        createdAt: now.subtract(const Duration(days: 1)),
        assignee: 'Sarah',
      ),
      Ticket(
        id: '103',
        title: 'Add dark mode support',
        description: 'Implement theme toggle and dark mode across the app.',
        status: TicketStatus.open,
        priority: TicketPriority.medium,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Ticket(
        id: '104',
        title: 'Export tickets to PDF',
        description: 'Allow users to download their tickets as PDF for offline use.',
        status: TicketStatus.resolved,
        priority: TicketPriority.medium,
        createdAt: now.subtract(const Duration(days: 3)),
        assignee: 'Mike',
      ),
      Ticket(
        id: '105',
        title: 'Notification delay',
        description: 'Push notifications arrive 5–10 minutes late.',
        status: TicketStatus.open,
        priority: TicketPriority.low,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  void _openDetail(Ticket ticket) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TicketDetailScreen(ticket: ticket),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundCream,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All tickets',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.02, end: 0, curve: Curves.easeOut),
            const SizedBox(height: 20),
            ...List.generate(
              _tickets.length,
              (i) => TicketCard(
                ticket: _tickets[i],
                index: i,
                onTap: () => _openDetail(_tickets[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
