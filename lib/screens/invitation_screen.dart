import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../app_theme.dart';
import '../models/wedding_ticket.dart';
import '../services/background_music.dart';
import '../widgets/animate_when_visible.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';
import '../widgets/location_qr_code.dart';
import '../widgets/wedding_ticket_card.dart';

/// Screen 2: Full invitation web-app with animation, music, image animation.
class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key, this.guestName});

  final String? guestName;

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final List<_WishEntry> _wishes = [
    _WishEntry(name: 'Theshy', message: '恭喜百年!', date: '30/12/2025, 15:50'),
    _WishEntry(name: 'Ramos', message: '新婚快乐 永结同心祝愿', date: '30/12/2025, 16:10'),
    _WishEntry(name: '拉莫斯', message: '愿幸福', date: '30/12/2025, 15:50'),
  ];
  static final DateTime _eventDate = DateTime(2027, 3, 20, 7, 0);
  int _days = 0, _hours = 0, _minutes = 0;
  Timer? _timer;
  bool _muted = true;
  final Set<String> _visibleSections = {};
  final Set<String> _exitingSections = {};
  final Map<String, Timer> _exitTimers = {};
  final Set<int> _galleryListVisibleIndices = {};
  static const int _exitDurationMs = 320;

  static const List<_TimelineEvent> _events = [
    _TimelineEvent(time: 'ម៉ោង ០៦:៣០ នាទីព្រឹក', label: 'ជួបជុំភ្ញៀវកិត្តិយសរៀបចំហែជំនួន', icon: Icons.people_rounded),
    _TimelineEvent(time: 'ម៉ោង ០៧:០០ នាទីព្រឹក', label: 'ហែជំនួន (កំណត់)', icon: Icons.dinner_dining_rounded),
    _TimelineEvent(
        time: 'ម៉ោង ០៨:០០ នាទីព្រឹក', label: 'ពិធីពិសាស្លាកំណត់ និងបំពាក់ចិញ្ចៀន', icon: Icons.favorite_rounded),
    _TimelineEvent(time: 'ម៉ោង ០៩:០០ នាទីព្រឹក', label: 'ពិធីកាត់សក់បង្កក់សិរី', icon: Icons.content_cut_rounded),
    _TimelineEvent(
        time: 'ម៉ោង ១០:០០ នាទីព្រឹក',
        label: 'ពិធីបើកវាំងនន បង្វិលពពិល ផ្ទឹម ចងដៃ និងបាចផ្កាស្លា',
        icon: Icons.celebration_rounded),
    _TimelineEvent(
        time: 'ម៉ោង ១១:១៥ នាទីព្រឹក', label: 'ពិធីសំពះទេវតាសែទូកង ចាក់ទឹកតែ', icon: Icons.local_cafe_rounded),
  ];

  static const WeddingTicket _sampleTicket = WeddingTicket(
    ticketId: 'WN-2026-0028',
    guestName: 'លោក-ទេពសត្យា',
    eventName: 'សិរីមង្គលអាពាហ៍ពិពាហ៍',
    eventDate: 'ថ្ងៃសៅរ៍ ទី២០ ខែមីនា ឆ្នាំ២០២៧',
    location: 'ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
    guestsCount: 1,
    tableNumber: '៥',
  );

  @override
  void initState() {
    super.initState();
    _muted = BackgroundMusic.instance.isMuted;
    _updateCountdown();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateCountdown());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _onSectionVisible('banner');
        _onSectionVisible('event');
      }
    });
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

  void _onSectionNotVisible(String key) {
    _exitTimers[key]?.cancel();
    _exitTimers.remove(key);
    if (!_visibleSections.contains(key)) return;
    setState(() => _exitingSections.add(key));
    _exitTimers[key] = Timer(const Duration(milliseconds: _exitDurationMs), () {
      if (!mounted) return;
      setState(() {
        _visibleSections.remove(key);
        _exitingSections.remove(key);
        _exitTimers.remove(key);
      });
    });
  }

  void _onSectionVisible(String key) {
    _exitTimers[key]?.cancel();
    _exitTimers.remove(key);
    setState(() {
      _visibleSections.add(key);
      _exitingSections.remove(key);
    });
  }

  @override
  void dispose() {
    for (final t in _exitTimers.values) {
      t.cancel();
    }
    _exitTimers.clear();
    _timer?.cancel();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Opens Google Calendar to add the wedding event (កត់ទុកក្នុងប្រតិទិន).
  Future<void> _addToCalendar() async {
    const utcOffsetHours = 7; // Cambodia UTC+7: local 07:00 = UTC 00:00
    final start = _eventDate;
    final end = start.add(const Duration(hours: 8));
    toUtc(DateTime d) => DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second)
        .subtract(const Duration(hours: utcOffsetHours));
    formatUtc(DateTime d) {
      final u = toUtc(d);
      final y = u.year;
      final m = u.month.toString().padLeft(2, '0');
      final day = u.day.toString().padLeft(2, '0');
      final h = u.hour.toString().padLeft(2, '0');
      final min = u.minute.toString().padLeft(2, '0');
      final s = u.second.toString().padLeft(2, '0');
      return '$y$m${day}T$h$min${s}Z';
    }

    final title = Uri.encodeComponent('សិរីមង្គលអាពាហ៍ពិពាហ៍');
    final location = Uri.encodeComponent('ភូមិសំរោងពក ឃុំអូតាប៉ោង ស្រុកបាកាន ខេត្តពោសាត់');
    final details = Uri.encodeComponent('ពិធីអាពាហ៍ពិពាហ៍');
    final dates = '${formatUtc(start)}/${formatUtc(end)}';
    final url = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=$title'
      '&dates=$dates'
      '&details=$details'
      '&location=$location',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _sendWish() {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    if (name.isEmpty || message.isEmpty) return;
    setState(() {
      _wishes.insert(0, _WishEntry(name: name, message: message, date: _formatDate(DateTime.now())));
      _nameController.clear();
      _messageController.clear();
    });
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}, '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleCount: 24,
          particleType: ParticleType.heart,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimateWhenVisible(
                        sectionKey: 'banner',
                        visible: _visibleSections.contains('banner'),
                        exiting: _exitingSections.contains('banner'),
                        onVisible: () => _onSectionVisible('banner'),
                        onNotVisible: () => _onSectionNotVisible('banner'),
                        child: _buildBannerImage(),
                      ),
                      const SizedBox(height: 32),
                      AnimateWhenVisible(
                        sectionKey: 'event',
                        visible: _visibleSections.contains('event'),
                        exiting: _exitingSections.contains('event'),
                        onVisible: () => _onSectionVisible('event'),
                        onNotVisible: () => _onSectionNotVisible('event'),
                        child: _buildEventInfoAndCalendar(),
                      ),
                      const SizedBox(height: 40),
                      AnimateWhenVisible(
                        sectionKey: 'program',
                        visible: _visibleSections.contains('program'),
                        exiting: _exitingSections.contains('program'),
                        onVisible: () => _onSectionVisible('program'),
                        onNotVisible: () => _onSectionNotVisible('program'),
                        child: _buildProgramTitleAndTimeline(),
                      ),
                      const SizedBox(height: 40),
                      AnimateWhenVisible(
                        sectionKey: 'ticket',
                        visible: _visibleSections.contains('ticket'),
                        exiting: _exitingSections.contains('ticket'),
                        onVisible: () => _onSectionVisible('ticket'),
                        onNotVisible: () => _onSectionNotVisible('ticket'),
                        child: _buildTicketSection(),
                      ),
                      const SizedBox(height: 40),
                      AnimateWhenVisible(
                        sectionKey: 'wishes',
                        visible: _visibleSections.contains('wishes'),
                        exiting: _exitingSections.contains('wishes'),
                        onVisible: () => _onSectionVisible('wishes'),
                        onNotVisible: () => _onSectionNotVisible('wishes'),
                        child: _buildWishesSection(),
                      ),
                      const SizedBox(height: 40),
                      AnimateWhenVisible(
                        sectionKey: 'gallery',
                        visible: _visibleSections.contains('gallery'),
                        exiting: _exitingSections.contains('gallery'),
                        onVisible: () => _onSectionVisible('gallery'),
                        onNotVisible: () => _onSectionNotVisible('gallery'),
                        child: _buildGallerySection(),
                      ),
                      const SizedBox(height: 40),
                      AnimateWhenVisible(
                        sectionKey: 'location',
                        visible: _visibleSections.contains('location'),
                        exiting: _exitingSections.contains('location'),
                        onVisible: () => _onSectionVisible('location'),
                        onNotVisible: () => _onSectionNotVisible('location'),
                        child: _buildLocationSection(),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 12, right: 16, child: LanguageButton(onTap: () {})),
                Positioned(
                  bottom: 20,
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

  static const String _bannerAsset = 'assets/images/Screenshot 2026-02-26 at 3.02.47 in the afternoon.png';

  void _openImageViewer(BuildContext context, String imageAsset) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => _FullScreenImageView(asset: imageAsset),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildBannerImage() {
    return GestureDetector(
      onTap: () => _openImageViewer(context, _bannerAsset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _bannerAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryPurple.withOpacity(0.2),
                        AppTheme.lavender.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.photo_camera_rounded,
                      size: 64,
                      color: AppTheme.primaryPurple.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.2)],
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: FallingParticles(
                  particleCount: 16,
                  particleType: ParticleType.petal,
                  child: SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventInfoAndCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ដែលនឹងប្រព្រឹត្តទៅ.\nថ្ងៃសៅរ៍ ទី២០ ខែមីនា ឆ្នាំ២០២៧,\nស្ថិតនៅគេហដ្ឋានខាងស្រី ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
          style: TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.5),
        )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 20),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _addToCalendar,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.deepPurple,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'កត់ទុកក្នុងប្រតិទិន',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.favorite_rounded, color: AppTheme.petalPink, size: 18),
                ],
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 440.ms, delay: 70.ms, curve: Curves.easeOutCubic)
            .slideY(begin: 0.03, end: 0, curve: Curves.easeOutCubic, delay: 70.ms),
      ],
    );
  }

  Widget _buildProgramTitleAndTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'កម្មវិធីសិរីមង្គលអាពាហ៍ពិពាហ៍',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.03, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        const Text(
          'ថ្ងៃទី២៨ ខែមករា ឆ្នាំ២០២៦',
          style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
        ).animate().fadeIn(duration: 440.ms, delay: 50.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: 8),
        const Text(
          'កម្មវិធីពេលព្រឹក',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple),
        ).animate().fadeIn(duration: 440.ms, delay: 90.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: 20),
        ...List.generate(_events.length, (i) {
          final event = _events[i];
          final isLast = i == _events.length - 1;
          return _TimelineRow(event: event, isLast: isLast, index: i);
        }),
      ],
    );
  }

  Widget _buildTicketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'សំបុត្ររបស់ខ្ញុំ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.025, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 16),
        const Center(
          child: WeddingTicketCard(ticket: _sampleTicket, animate: true),
        ),
      ],
    );
  }

  Widget _buildWishesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ផ្ញើសារជូនពរ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.025, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 16),
        Container(
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
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'ឈ្មោះ...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.lightLavender),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.lightLavender),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'សរសេរសារជូនពរ...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.lightLavender),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.lightLavender),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _sendWish,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('ផ្ញើ'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'សារជូនពរ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        ),
        const SizedBox(height: 12),
        ...List.generate(_wishes.length, (i) {
          final w = _wishes[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCream.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.lightLavender),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${w.name}:',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(w.message, style: const TextStyle(color: AppTheme.textDark, fontSize: 14, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(w.date, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  /// All image blocks use files from assets/images/
  static const List<String> _galleryAssets = [
    'assets/images/Screenshot 2026-02-26 at 3.02.47 in the afternoon.png',
    'assets/images/Screenshot 2026-02-26 at 2.58.52 in the afternoon.png',
    'assets/images/Screenshot 2026-02-26 at 2.59.25 in the afternoon.png',
    'assets/images/Screenshot 2026-02-26 at 2.59.39 in the afternoon.png',
    'assets/images/Screenshot 2026-02-26 at 3.00.11 in the afternoon.png',
    'assets/images/Screenshot 2026-02-26 at 3.02.28 in the afternoon.png',
    'assets/images/Screenshot_2026-02-26_at_4.43.57_in_the_afternoon.png',
  ];

  /// Animated placeholder for failed gallery images (fade + scale in).
  Widget _buildGalleryPlaceholder({int animationDelayMs = 0}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightLavender,
            AppTheme.lavender.withOpacity(0.5),
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.photo_library_rounded, size: 48, color: AppTheme.primaryPurple.withOpacity(0.5)),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: animationDelayMs.ms, curve: Curves.easeOutCubic).scale(
        begin: const Offset(0.92, 0.92),
        end: const Offset(1, 1),
        duration: 400.ms,
        delay: animationDelayMs.ms,
        curve: Curves.easeOutCubic);
  }

  /// Gallery: 2 images (animationDelay) → 1 big image → vertical list (scroll up).
  Widget _buildGallerySection() {
    const int delayImage1 = 0;
    const int delayImage2 = 120;
    const int delayBigImage = 220;

    final topTwoAssets = _galleryAssets.length >= 2 ? _galleryAssets.sublist(0, 2) : _galleryAssets;
    final bigImageAsset =
        _galleryAssets.length > 2 ? _galleryAssets[2] : (_galleryAssets.isNotEmpty ? _galleryAssets.first : null);
    final listAssets = _galleryAssets.length > 3 ? _galleryAssets.sublist(3) : <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'វិចិត្រសាល',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        ),
        const SizedBox(height: 16),
        // 1) Two images with animation delay (when user scrolls up into view)
        Row(
          children: [
            Expanded(
              child: _buildGalleryImageCard(topTwoAssets.isNotEmpty ? topTwoAssets[0] : null, delayImage1, 160),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: topTwoAssets.length > 1
                  ? _buildGalleryImageCard(topTwoAssets[1], delayImage2, 160)
                  : const SizedBox(height: 160),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 2) One big image under the two
        if (bigImageAsset != null) _buildGalleryImageCard(bigImageAsset, delayBigImage, 200, isBig: true),
        if (bigImageAsset != null) const SizedBox(height: 12),
        // 3) List of images, scroll direction up (vertical list)
        if (listAssets.isNotEmpty) ...[
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: listAssets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return VisibilityDetector(
                  key: Key('gallery_list_$index'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction >= 0.25 && !_galleryListVisibleIndices.contains(index)) {
                      setState(() => _galleryListVisibleIndices.add(index));
                    }
                  },
                  child: _buildGalleryListImageCard(
                    listAssets[index],
                    140,
                    visible: _galleryListVisibleIndices.contains(index),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGalleryImageCard(String? asset, int delayMs, double height, {bool isBig = false}) {
    final content = _buildGalleryCardContent(
      context,
      asset: asset,
      height: height,
      isBig: isBig,
      placeholderDelayMs: delayMs,
    );
    return content
        .animate()
        .fadeIn(duration: 440.ms, delay: delayMs.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.06, end: 0, duration: 440.ms, delay: delayMs.ms, curve: Curves.easeOutCubic)
        .scale(
            begin: const Offset(0.96, 0.96),
            end: const Offset(1, 1),
            duration: 440.ms,
            delay: delayMs.ms,
            curve: Curves.easeOutCubic);
  }

  /// List image: animates when user scrolls and the item meets the viewport.
  Widget _buildGalleryListImageCard(String asset, double height, {required bool visible}) {
    final content = _buildGalleryCardContent(
      context,
      asset: asset,
      height: height,
      isBig: false,
      placeholderDelayMs: 0,
    );
    if (!visible) {
      return Opacity(opacity: 0, child: content);
    }
    return content
        .animate()
        .fadeIn(duration: 420.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.08, end: 0, duration: 420.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.94, 0.94), end: const Offset(1, 1), duration: 420.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildGalleryCardContent(
    BuildContext context, {
    required String? asset,
    required double height,
    required bool isBig,
    required int placeholderDelayMs,
  }) {
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: isBig ? double.infinity : null,
        child: asset != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildGalleryPlaceholder(animationDelayMs: placeholderDelayMs),
                  ),
                  Positioned.fill(
                    child: FallingParticles(
                      particleCount: isBig ? 18 : 12,
                      particleType: isBig ? ParticleType.heart : ParticleType.petal,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              )
            : _buildGalleryPlaceholder(animationDelayMs: placeholderDelayMs),
      ),
    );
    if (asset != null) {
      return GestureDetector(
        onTap: () => _openImageViewer(context, asset),
        child: child,
      );
    }
    return child;
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, color: AppTheme.primaryPurple, size: 22),
            SizedBox(width: 8),
            Text(
              'ទីតាំងកម្មវិធី',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
            ),
          ],
        ),
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
          child: const Column(
            children: [
              LocationQrCode(size: 200),
              SizedBox(height: 12),
              Text(
                'ស្កែនឬចុចដើម្បីមើលទីតាំង',
                style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'រាប់ថយក្រោយទៅដល់ថ្ងៃកម្មវិធី',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.deepPurple),
        ),
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
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.lightLavender.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lavender.withOpacity(0.5)),
          ),
          child: const Text(
            'ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
            style: TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.4),
          ),
        ),
      ],
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

class _FullScreenImageView extends StatelessWidget {
  const _FullScreenImageView({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image_rounded, size: 64, color: Colors.white54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineEvent {
  const _TimelineEvent({required this.time, required this.label, this.icon});
  final String time;
  final String label;
  final IconData? icon;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast, required this.index});
  final _TimelineEvent event;
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.label,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 440.ms, delay: (55 * index).ms, curve: Curves.easeOutCubic)
        .slideX(begin: 0.02, end: 0, curve: Curves.easeOutCubic, delay: (55 * index).ms);
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.label, required this.value});
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
          Text('$value',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryPurple)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

class _WishEntry {
  _WishEntry({required this.name, required this.message, required this.date});
  final String name;
  final String message;
  final String date;
}
