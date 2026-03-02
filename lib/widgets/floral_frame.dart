import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Decorative floral-style border framing the content (simplified floral motif).
class FloralFrame extends StatelessWidget {
  const FloralFrame({
    super.key,
    required this.child,
    this.inset = 0,
    this.backgroundImage,
  });

  final Widget child;
  final double inset;

  /// Optional background image path (e.g. 'assets/images/bg_first.png'). If null, uses default.
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundImage ?? 'assets/images/Designer.png';
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(
            bg,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppTheme.backgroundCream),
          ),
        ),
        child,
        // Positioned.fill(
        //   child: IgnorePointer(
        //     child: CustomPaint(
        //       painter: _FloralBorderPainter(inset: inset),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _FloralBorderPainter extends CustomPainter {
  _FloralBorderPainter({this.inset = 0});
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    const colors = [
      AppTheme.lavender,
      AppTheme.primaryPurple,
      AppTheme.petalPink,
    ];
    final random = Random(42);

    // Top border – floral clusters
    _drawFloralBand(
      canvas,
      Rect.fromLTRB(inset, 0, size.width - inset, 80),
      colors,
      random,
      top: true,
    );
    // Bottom border
    _drawFloralBand(
      canvas,
      Rect.fromLTRB(inset, size.height - 70, size.width - inset, size.height),
      colors,
      random,
      top: false,
    );
    // Left edge
    _drawSideFlorals(
      canvas,
      Rect.fromLTRB(0, 0, 40, size.height),
      colors,
      random,
    );
    // Right edge
    _drawSideFlorals(
      canvas,
      Rect.fromLTRB(size.width - 40, 0, size.width, size.height),
      colors,
      random,
    );
  }

  void _drawFloralBand(
    Canvas canvas,
    Rect rect,
    List<Color> colors,
    Random random, {
    required bool top,
  }) {
    final w = rect.width;
    final h = rect.height;
    final centerY = rect.top + h / 2;
    for (var i = 0; i < 25; i++) {
      final x = rect.left + (i / 24) * w + (random.nextDouble() - 0.5) * 20;
      final y = centerY + (random.nextDouble() - 0.5) * h * 0.8;
      final r = 6.0 + random.nextDouble() * 10;
      final color = colors[random.nextInt(colors.length)].withOpacity(0.3 + random.nextDouble() * 0.5);
      canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
      canvas.drawCircle(
        Offset(x + 3, y - 2),
        r * 0.6,
        Paint()..color = color.withOpacity(0.6),
      );
    }
  }

  void _drawSideFlorals(
    Canvas canvas,
    Rect rect,
    List<Color> colors,
    Random random,
  ) {
    const step = 60.0;
    for (var y = rect.top; y < rect.bottom; y += step) {
      final x = rect.left + rect.width / 2 + (random.nextDouble() - 0.5) * 20;
      final r = 4 + random.nextDouble() * 8;
      final color = colors[random.nextInt(colors.length)].withOpacity(0.25 + random.nextDouble() * 0.4);
      canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
