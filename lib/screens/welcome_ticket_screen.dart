import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../services/background_music.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';
import 'invitation_screen.dart';

/// Screen 1: Welcome with "Open ticket" button; shows guest name (ភ្ញៀវ) when provided.
class WelcomeTicketScreen extends StatefulWidget {
  const WelcomeTicketScreen({super.key, this.guestName});

  final String? guestName;

  @override
  State<WelcomeTicketScreen> createState() => _WelcomeTicketScreenState();
}

class _WelcomeTicketScreenState extends State<WelcomeTicketScreen> {
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    BackgroundMusic.instance.init();
    // Start music (will no-op if no asset); start muted so user can tap to unmute
    BackgroundMusic.instance.setMuted(true);
  }

  void _openTicket() {
    // Start playing music when user opens the ticket
    BackgroundMusic.instance.setMuted(false);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => InvitationScreen(guestName: widget.guestName),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 480),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        backgroundImage: 'assets/images/bg_first.png',
        child: FallingParticles(
          particleCount: 18,
          particleType: ParticleType.petal,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 100),
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
                      )
                          .animate()
                          .fadeIn(duration: 560.ms, curve: Curves.easeOutCubic)
                          .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 20),
                      _buildMonogram(),
                      //  const SizedBox(height: 20),
                      const Text(
                        'សូមគោរពអញ្ជើញ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ).animate().fadeIn(duration: 480.ms, delay: 140.ms, curve: Curves.easeOutCubic).scale(
                          begin: const Offset(0.96, 0.96),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutCubic,
                          delay: 140.ms),
                      const SizedBox(height: 8),
                      Text(
                        widget.guestName != null && widget.guestName!.isNotEmpty ? widget.guestName! : 'លោក-ទេពសត្យា',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Battambang, Moul',
                        ),
                      ).animate().fadeIn(duration: 480.ms, delay: 220.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 32),
                      _buildCoupleIllustration(),
                      const SizedBox(height: 36),
                      _buildOpenTicketButton(),
                    ],
                  ),
                ),
                Positioned(top: 12, right: 16, child: LanguageButton(onTap: () {})),
                Positioned(
                  bottom: -800,
                  right: 20,
                  child: _MusicButton(
                    muted: _muted,
                    onTap: () {
                      setState(() {
                        _muted = !_muted;
                        BackgroundMusic.instance.setMuted(_muted);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonogram() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Image.asset(
        'assets/images/golo.png',
        width: 200,
        height: 200,
      ),
    )
        .animate()
        .fadeIn(duration: 480.ms, delay: 100.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.88, 0.88), end: const Offset(1, 1), curve: Curves.easeOutCubic, delay: 100.ms);
  }

  Widget _buildCoupleIllustration() {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(AppTheme.lightLavender, Icons.person_rounded),
          const SizedBox(width: 16),
          const Icon(Icons.favorite_rounded, color: AppTheme.petalPink, size: 28),
          const SizedBox(width: 16),
          _buildAvatar(AppTheme.lightLavender, Icons.person_rounded),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 480.ms, delay: 300.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic, delay: 300.ms);
  }

  Widget _buildAvatar(Color bg, IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Icon(icon, size: 40, color: AppTheme.primaryPurple.withOpacity(0.7)),
    );
  }

  Widget _buildOpenTicketButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openTicket,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppTheme.deepPurple,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'បើកធៀប',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 520.ms, delay: 380.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic, delay: 380.ms)
        .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1), curve: Curves.easeOutCubic, delay: 380.ms);
  }
}

class _MusicButton extends StatelessWidget {
  const _MusicButton({required this.muted, required this.onTap});
  final bool muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.deepPurple.withOpacity(0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
