import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static final DateTime _eventDate = DateTime(2026, 1, 28, 8, 0);
  int _days = 0, _hours = 0, _minutes = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    final now = DateTime.now();
    if (now.isAfter(_eventDate)) {
      setState(() {
        _days = 0;
        _hours = 0;
        _minutes = 0;
      });
      return;
    }
    final diff = _eventDate.difference(now);
    setState(() {
      _days = diff.inDays;
      _hours = diff.inHours % 24;
      _minutes = diff.inMinutes % 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleCount: 16,
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
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_rounded, color: AppTheme.primaryPurple, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'ទីតាំងកម្មវិធី',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.deepPurple,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOut),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.cardWhite,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryPurple.withOpacity(0.1),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'QR Code',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'ស្កែនឬចុចដើម្បីមើលទីតាំង',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
                                    ),
                                  ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'រាប់ថយក្រោយទៅដល់ថ្ងៃកម្មវិធី',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.deepPurple,
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _CountdownCard(label: 'ថ្ងៃ', value: _days),
                                const SizedBox(width: 12),
                                _CountdownCard(label: 'ម៉ោង', value: _hours),
                                const SizedBox(width: 12),
                                _CountdownCard(label: 'នាទី', value: _minutes),
                              ],
                            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(
                                begin: const Offset(0.92, 0.92),
                                end: const Offset(1, 1),
                                curve: Curves.easeOut,
                                delay: 200.ms),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.lightLavender.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.lavender.withOpacity(0.5)),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ភូមិដើមចារ ឃុំកំពង់ត្រាចខាងលិច\nស្រុកកំពង់ត្រាច ខេត្តកំពត',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textDark,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 340.ms),
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

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
