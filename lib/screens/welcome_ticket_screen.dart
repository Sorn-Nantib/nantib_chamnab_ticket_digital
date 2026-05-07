import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../services/background_music.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';
import 'invitation_screen.dart';

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
        pageBuilder: (_, __, ___) =>
            InvitationScreen(guestName: widget.guestName),
        transitionsBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
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
            child: Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        'សិរីមង្គលអាពាហ៍ពិពាហ៍',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                            height: 1.3,
                            fontFamily: 'KHMEROSMUOLLIGHT'),
                      )
                          .animate()
                          .fadeIn(duration: 560.ms, curve: Curves.easeOutCubic)
                          .slideY(
                              begin: -0.08, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 20),
                      _buildMonogram(),
                      const SizedBox(height: 20),
                      const Text(
                        'សូមគោរពអញ្ជើញ',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepPurple,
                            fontFamily: 'KantumruyProMedium'),
                      )
                          .animate()
                          .fadeIn(
                              duration: 480.ms,
                              delay: 140.ms,
                              curve: Curves.easeOutCubic)
                          .scale(
                              begin: const Offset(0.96, 0.96),
                              end: const Offset(1, 1),
                              curve: Curves.easeOutCubic,
                              delay: 140.ms),
                      const SizedBox(height: 8),
                      
                      Text(
                        widget.guestName != null && widget.guestName!.isNotEmpty
                            ? widget.guestName!
                            : 'លោក-ទេពសត្យា',
                        style: const  TextStyle(
                          fontSize: 24,
                          color: AppTheme.cardWhite,
                          fontWeight: FontWeight.w600,             
                           fontFamily: 'KHMEROSMUOLLIGHT',
                           shadows: [
                            Shadow(
                              color: AppTheme.primaryPurple,
                              offset: Offset(2,2),
                              blurRadius: 0.3,
                            ),
                             Shadow(
                              color: AppTheme.primaryPurple,
                              offset: Offset(-2,-2),
                              blurRadius: 0.3,
                            ),
                            ]
                        ),
                      ).animate().fadeIn(
                          duration: 480.ms,
                          delay: 220.ms,
                          curve: Curves.easeOutCubic),
                    ],
                  ),
                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: _buildOpenTicketButton(),
                  ),
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
      ),
    );
  }

  Widget _buildMonogram() {
    return SizedBox(
      child: Image.asset(
        'assets/images/golo.png',
        width: 120,
        height: 120,
      ),
    )
        .animate()
        .fadeIn(duration: 480.ms, delay: 100.ms, curve: Curves.easeOutCubic)
        .scale(
            begin: const Offset(0.88, 0.88),
            end: const Offset(1, 1),
            curve: Curves.easeOutCubic,
            delay: 100.ms);
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
      child:
          Icon(icon, size: 40, color: AppTheme.primaryPurple.withOpacity(0.7)),
    );
  }

  Widget _buildOpenTicketButton() {
    return InkWell(
      onTap: _openTicket,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 200,
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
    )
        .animate()
        .fadeIn(duration: 520.ms, delay: 380.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic, delay: 380.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          curve: Curves.easeOutCubic,
          delay: 380.ms,
        );
  }
}

class _PosterGlow extends StatelessWidget {
  const _PosterGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1),
          radius: 0.78,
          colors: [
            const Color(0xFFFFE7A7).withValues(alpha: 0.78),
            const Color(0xFFFFE7A7).withValues(alpha: 0.18),
            Colors.transparent,
          ],
          stops: const [0.0, 0.22, 1.0],
        ),
      ),
    );
  }
}

class _PosterSideOrnaments extends StatelessWidget {
  const _PosterSideOrnaments({this.flip = false});

  final bool flip;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: 26,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          17,
          (_) => const Icon(
            Icons.spa_rounded,
            size: 22,
            color: Color(0xFFD69A67),
            shadows: [
              Shadow(
                color: Color(0xFF6A3D1E),
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );

    if (!flip) return child;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14159),
      child: child,
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'រំលង',
            style: TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
              fontFamily: 'KHMEROSSIEMREAP',
            ),
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
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
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppTheme.textDark,
            size: 24,
          ),
        ),
      ),
    );
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
            color: AppTheme.primaryPurple.withValues(alpha: 0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
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
