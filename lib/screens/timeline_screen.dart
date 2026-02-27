import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';

class TimelineEvent {
  const TimelineEvent({
    required this.time,
    required this.label,
    this.icon,
  });
  final String time;
  final String label;
  final IconData? icon;
}

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  static const List<TimelineEvent> _events = [
    TimelineEvent(
      time: 'ម៉ោង ០៦:៣០ នាទីព្រឹក',
      label: 'ជួបជុំភ្ញៀវកិត្តិយសរៀបចំហែជំនួន',
      icon: Icons.people_rounded,
    ),
    TimelineEvent(
      time: 'ម៉ោង ០៧:០០ នាទីព្រឹក',
      label: 'ហែជំនួន (កំណត់)',
      icon: Icons.dinner_dining_rounded,
    ),
    TimelineEvent(
      time: 'ម៉ោង ០៨:០០ នាទីព្រឹក',
      label: 'ពិធីពិសាស្លាកំណត់ និងបំពាក់ចិញ្ចៀន',
      icon: Icons.favorite_rounded,
    ),
    TimelineEvent(
      time: 'ម៉ោង ០៩:០០ នាទីព្រឹក',
      label: 'ពិធីកាត់សក់បង្កក់សិរី',
      icon: Icons.content_cut_rounded,
    ),
    TimelineEvent(
      time: 'ម៉ោង ១០:០០ នាទីព្រឹក',
      label: 'ពិធីបើកវាំងនន បង្វិលពពិល ផ្ទឹម ចងដៃ និងបាចផ្កាស្លា',
      icon: Icons.celebration_rounded,
    ),
    TimelineEvent(
      time: 'ម៉ោង ១១:១៥ នាទីព្រឹក',
      label: 'ពិធីសំពះទេវតាសែទូកង ចាក់ទឹកតែ',
      icon: Icons.local_cafe_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleCount: 18,
          particleType: ParticleType.petal,
          child: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'កម្មវិធីពេលព្រឹក',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepPurple,
                              ),
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOut),
                            const SizedBox(height: 24),
                            ...List.generate(_events.length, (i) {
                              final event = _events[i];
                              final isLast = i == _events.length - 1;
                              return _TimelineRow(
                                event: event,
                                isLast: isLast,
                                index: i,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(top: 12, right: 16, child: LanguageButton(onTap: () {})),
                Positioned(
                  top: 12,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppTheme.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.event,
    required this.isLast,
    required this.index,
  });

  final TimelineEvent event;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                if (event.icon != null)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.lightLavender,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryPurple, width: 2),
                    ),
                    child: Icon(event.icon, size: 18, color: AppTheme.primaryPurple),
                  ),
                if (!isLast)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: VerticalDivider(
                        thickness: 3,
                        color: AppTheme.primaryPurple.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (80 * index).ms)
        .slideX(begin: 0.04, end: 0, curve: Curves.easeOut, delay: (80 * index).ms);
  }
}
