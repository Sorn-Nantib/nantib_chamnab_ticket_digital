import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../models/wedding_ticket.dart';

class WeddingTicketCard extends StatelessWidget {
  const WeddingTicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.animate = true,
  });

  final WeddingTicket ticket;
  final VoidCallback? onTap;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppTheme.lavender.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppTheme.lightLavender, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                _buildDashedDivider(),
                _buildBody(context),
                _buildDashedDivider(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );

    if (animate) {
      return content
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(
            begin: const Offset(0.96, 0.96),
            end: const Offset(1, 1),
            curve: Curves.easeOut,
          );
    }
    return content;
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withOpacity(0.12),
            AppTheme.lightLavender.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            ticket.eventName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'KHMEROSMUOLLIGHT',
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ticket.eventDate,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'BattambangRegular',
              color: AppTheme.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return CustomPaint(
      size: const Size(double.infinity, 12),
      painter: _DashedLinePainter(color: AppTheme.lavender.withOpacity(0.6)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ភ្ញៀវ',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'BattambangRegular',
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.guestName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'BattambangRegular',
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ticket.location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'BattambangRegular',
                    color: AppTheme.textMuted,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo_name.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    const dashWidth = 8.0;
    const gap = 6.0;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
