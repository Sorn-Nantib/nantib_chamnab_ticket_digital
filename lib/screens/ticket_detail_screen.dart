import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../models/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.ticket});

  final Ticket ticket;

  Color _statusColor(TicketStatus s) {
    switch (s) {
      case TicketStatus.open:
        return Colors.blue;
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.resolved:
        return Colors.green;
      case TicketStatus.closed:
        return Colors.grey;
    }
  }

  Color _priorityColor(TicketPriority p) {
    switch (p) {
      case TicketPriority.low:
        return Colors.teal;
      case TicketPriority.medium:
        return Colors.amber;
      case TicketPriority.high:
        return Colors.deepOrange;
      case TicketPriority.critical:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('#${t.id}'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(t.status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          t.statusLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _statusColor(t.status),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOut),
                      const SizedBox(height: 16),
                      Text(
                        t.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 350.ms, delay: 50.ms)
                          .slideX(begin: -0.02, end: 0, curve: Curves.easeOut, delay: 50.ms),
                      const SizedBox(height: 12),
                      Text(
                        t.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppTheme.textSecondary,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 350.ms, delay: 100.ms)
                          .slideX(begin: -0.02, end: 0, curve: Curves.easeOut, delay: 100.ms),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _detailChip(
                  label: 'Priority',
                  value: t.priorityLabel,
                  color: _priorityColor(t.priority),
                ),
                _detailChip(
                  label: 'Created',
                  value: _formatDate(t.createdAt),
                  color: AppTheme.textSecondary,
                ),
                if (t.assignee != null)
                  _detailChip(
                    label: 'Assignee',
                    value: t.assignee!,
                    color: AppTheme.primaryPurple,
                  ),
              ],
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms)
                .slideY(begin: 0.05, end: 0, curve: Curves.easeOut, delay: 150.ms),
          ],
        ),
      ),
    );
  }

  Widget _detailChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}
