import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nantib_chamnab_ticket_digital/app_theme.dart';

class GeminiAnimatedBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double borderRadius;
  final List<Color> gradientColors;
  final Duration duration;

  const GeminiAnimatedBorder({
    super.key,
    required this.child,
    this.borderWidth = 4.0,
    this.borderRadius = 100,
    this.gradientColors = const [
      AppTheme.primaryPurple,
      AppTheme.lightPurple,
      AppTheme.primaryPurple,
      AppTheme.lightLavender,
    ],
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<GeminiAnimatedBorder> createState() => _GeminiAnimatedBorderState();
}

class _GeminiAnimatedBorderState extends State<GeminiAnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Intializes the rotation loop continuously
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BorderGradientPainter(
            rotationAngle: _controller.value * 2 * math.pi,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            colors: widget.gradientColors,
          ),
          child: ClipRRect(
            // Matches the inner content to the border profile
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _BorderGradientPainter extends CustomPainter {
  final double rotationAngle;
  final double borderWidth;
  final double borderRadius;
  final List<Color> colors;

  _BorderGradientPainter({
    required this.rotationAngle,
    required this.borderWidth,
    required this.borderRadius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Creates the sweeping gradient brush tracking Gemini AI styling
    final Paint paint =
        Paint()
          ..shader = SweepGradient(
            colors: colors,
            transform: GradientRotation(rotationAngle),
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, paint);
  }

  // @override
  // bool _shouldRepaint(covariant _BorderGradientPainter oldDelegate) {
  //   return oldDelegate.rotationAngle != rotationAngle;
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
