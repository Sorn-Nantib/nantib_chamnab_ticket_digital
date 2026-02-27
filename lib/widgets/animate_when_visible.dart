import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Scroll-triggered animations: smooth entrance when in view, smooth exit when scrolling up.
class AnimateWhenVisible extends StatefulWidget {
  const AnimateWhenVisible({
    super.key,
    required this.sectionKey,
    required this.child,
    required this.visible,
    required this.exiting,
    required this.onVisible,
    required this.onNotVisible,
    this.threshold = 0.18,
    this.exitThreshold = 0.12,
    this.duration = 500,
    this.exitDuration = 360,
    this.delay = 0,
    this.slideOffset = const Offset(0, 0.05),
    this.exitSlideOffset = const Offset(0, -0.06),
    this.curve = Curves.easeOutCubic,
    this.exitCurve = Curves.easeInCubic,
  });

  final String sectionKey;
  final Widget child;
  final bool visible;
  final bool exiting;
  final VoidCallback onVisible;
  final VoidCallback onNotVisible;
  final double threshold;
  final double exitThreshold;
  final int duration;
  final int exitDuration;
  final int delay;
  final Offset slideOffset;
  final Offset exitSlideOffset;
  final Curve curve;
  final Curve exitCurve;

  @override
  State<AnimateWhenVisible> createState() => _AnimateWhenVisibleState();
}

class _AnimateWhenVisibleState extends State<AnimateWhenVisible> {
  bool _lastWasVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('visible_${widget.sectionKey}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction >= widget.threshold) {
          widget.onVisible();
          _lastWasVisible = true;
        } else if (info.visibleFraction < widget.exitThreshold && _lastWasVisible) {
          _lastWasVisible = false;
          widget.onNotVisible();
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.exiting) {
      return widget.child.animate().fadeOut(duration: widget.exitDuration.ms, curve: widget.exitCurve).slideY(
            begin: 0,
            end: widget.exitSlideOffset.dy,
            duration: widget.exitDuration.ms,
            curve: widget.exitCurve,
          );
    }
    if (widget.visible) {
      return widget.child
          .animate()
          .fadeIn(duration: widget.duration.ms, delay: widget.delay.ms, curve: widget.curve)
          .slideY(
            begin: widget.slideOffset.dy,
            end: 0,
            duration: widget.duration.ms,
            delay: widget.delay.ms,
            curve: widget.curve,
          )
          .scale(
            begin: const Offset(0.98, 0.98),
            end: const Offset(1, 1),
            duration: widget.duration.ms,
            delay: widget.delay.ms,
            curve: widget.curve,
          );
    }
    return Opacity(opacity: 0, child: widget.child);
  }
}
