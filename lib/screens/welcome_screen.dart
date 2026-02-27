import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';
import 'timeline_screen.dart';
import 'wishes_screen.dart';
import 'location_screen.dart';

/// Opening screen: invitation title, names, and "Open invitation" CTA.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleCount: 20,
          particleType: ParticleType.petal,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 100),
                  child: Column(
                    children: [
                      const Text(
                        'សិរីមង្គលអាពាហ៍ពិពាហ៍',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepPurple,
                          height: 1.3,
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
                      const SizedBox(height: 16),
                      const Text(
                        'ថ្ងៃពុធ ទី២៨ ខែមករា ឆ្នាំ២០២៦',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                      const SizedBox(height: 24),
                      const Text(
                        'លោក Yong Xing  និង អ្នកស្រី Xiao Ping\nលោក វ៉ាន់ សាវុធ និង អ្នកស្រី យ៉េង គា',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textDark,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                      const SizedBox(height: 20),
                      const Text(
                        'សូមគោរពអញ្ជើញ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
                      const SizedBox(height: 28),
                      const Text(
                        'កូនប្រុស xiao zhi  ជាគូនឹង  កូនស្រី xiao mei',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepPurple,
                        ),
                      ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                      const SizedBox(height: 20),
                      const Text(
                        'ដែលនឹងប្រព្រឹត្តទៅនៅ\nភូមិដើមចារ ឃុំកំពង់ត្រាចខាងលិច',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 16,
                  child: LanguageButton(onTap: () {}),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 32,
                  child: _OpenInvitationButton(
                    onTap: () => _openInvitation(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openInvitation(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const InvitationMenuScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}

class _OpenInvitationButton extends StatefulWidget {
  const _OpenInvitationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_OpenInvitationButton> createState() => _OpenInvitationButtonState();
}

class _OpenInvitationButtonState extends State<_OpenInvitationButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.deepPurple,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'បើកធៀប',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 700.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut, delay: 700.ms);
  }
}

/// Menu after "Open invitation": Program, Wishes, Location.
class InvitationMenuScreen extends StatelessWidget {
  const InvitationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleType: ParticleType.heart,
          child: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
                        child: Column(
                          children: [
                            const Text(
                              'កម្មវិធីសិរីមង្គលអាពាហ៍ពិពាហ៍',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepPurple,
                              ),
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOut),
                            const SizedBox(height: 8),
                            const Text(
                              'ថ្ងៃទី២៨ ខែមករា ឆ្នាំ២០២៦',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textMuted,
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                            const SizedBox(height: 32),
                            _MenuTile(
                              title: 'កម្មវិធីពេលព្រឹក',
                              subtitle: 'តារាងកម្មវិធី',
                              icon: Icons.schedule_rounded,
                              delay: 0,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TimelineScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _MenuTile(
                              title: 'សារជូនពរ',
                              subtitle: 'ផ្ញើសារជូនពរ',
                              icon: Icons.favorite_rounded,
                              delay: 100,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const WishesScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _MenuTile(
                              title: 'ទីតាំងកម្មវិធី',
                              subtitle: 'ស្កែនឬចុចដើម្បីមើលទីតាំង',
                              icon: Icons.location_on_rounded,
                              delay: 200,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LocationScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  right: 16,
                  child: LanguageButton(onTap: () {}),
                ),
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.delay,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightLavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryPurple, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (200 + delay).ms)
        .slideX(begin: 0.03, end: 0, curve: Curves.easeOut, delay: (200 + delay).ms);
  }
}
