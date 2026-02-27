import 'dart:math' show Random, sin, pi;
import 'package:flutter/material.dart';

/// Falling petals/hearts overlay matching the invitation video.
class FallingParticles extends StatefulWidget {
  const FallingParticles({
    super.key,
    this.child,
    this.particleCount = 25,
    this.particleType = ParticleType.petal,
  });

  final Widget? child;
  final int particleCount;
  final ParticleType particleType;

  @override
  State<FallingParticles> createState() => _FallingParticlesState();
}

enum ParticleType { petal, heart, circle }

class _FallingParticlesState extends State<FallingParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    for (var i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        delay: _random.nextDouble(),
        size: 4 + _random.nextDouble() * 8,
        duration: 8 + _random.nextDouble() * 12,
        colorIndex: _random.nextInt(3),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _FallingParticlesPainter(
                    particles: _particles,
                    progress: _controller.value,
                    type: widget.particleType,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.delay,
    required this.size,
    required this.duration,
    required this.colorIndex,
  });
  final double x;
  final double delay;
  final double size;
  final double duration;
  final int colorIndex;
}

class _FallingParticlesPainter extends CustomPainter {
  _FallingParticlesPainter({
    required this.particles,
    required this.progress,
    required this.type,
  });

  final List<_Particle> particles;
  final double progress;
  final ParticleType type;

  static const List<Color> _colors = [
    Color(0xFFE8B4C4),
    Color(0xFFB8A9D4),
    Color(0xFFF0C0D0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress + p.delay) % 1.0;
      final y = t * (size.height + 50) - 25;
      final drift = sin(t * pi * 2) * 8;
      final x = size.width * p.x + drift;
      final normY = (y / size.height).clamp(0.0, 1.0);
      final opacity = (0.5 - (normY - 0.5).abs()) * 0.9 + 0.15;
      final color = _colors[p.colorIndex % _colors.length].withOpacity(opacity.clamp(0.0, 0.65));

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 0.35);

      final paint = Paint()..color = color;
      if (type == ParticleType.heart) {
        _drawHeart(canvas, paint, p.size);
      } else if (type == ParticleType.petal) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: p.size * 2, height: p.size),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size, paint);
      }
      canvas.restore();
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, double size) {
    final path = Path();
    path.moveTo(0, size * 0.3);
    path.cubicTo(-size, -size * 0.5, -size * 1.5, size * 0.5, 0, size * 1.2);
    path.cubicTo(size * 1.5, size * 0.5, size, -size * 0.5, 0, size * 0.3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FallingParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
