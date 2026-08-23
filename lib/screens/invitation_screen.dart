import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nantib_chamnab_ticket_digital/screens/Image_block.dart';
import 'package:nantib_chamnab_ticket_digital/screens/coun_down.dart';
import 'package:nantib_chamnab_ticket_digital/widgets/custom_date.dart';
import 'package:nantib_chamnab_ticket_digital/widgets/custom_even_tap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../models/wedding_ticket.dart';
import '../services/background_music.dart';
import '../widgets/animate_when_visible.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/location_qr_code.dart';
import '../widgets/wedding_ticket_card.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _WishEntry(
      name: 'Ramos',
      message: '新婚快乐 永结同心祝愿',
      date: '30/12/2025, 16:10',
    ),
    _WishEntry(name: '拉莫斯', message: '愿幸福', date: '30/12/2025, 15:50'),
  ];
  static final DateTime _eventDate = DateTime(2027, 3, 20, 17, 0);
  int _days = 0, _hours = 0, _minutes = 0, _seconds = 0;
  Timer? _timer;
  bool _muted = true;
  final Set<String> _visibleSections = {};
  final Set<String> _exitingSections = {};
  final Map<String, Timer> _exitTimers = {};
  static const int _exitDurationMs = 320;
  // remembers selected program tab (so visibility rebuilds won't reset it)
  int _programTabIndex = 0;

  /// On web/desktop wide windows the invitation reads best at phone-like width.
  static const double _maxInvitationContentWidth = 480;

  double _contentWidth(BuildContext context) {
    return math.min(
      MediaQuery.sizeOf(context).width,
      _maxInvitationContentWidth,
    );
  }

  double _responsiveScale(BuildContext context) {
    final width = _contentWidth(context);
    return (width / _maxInvitationContentWidth).clamp(0.82, 1.0);
  }

  double _responsiveFont(BuildContext context, double size, {double min = 12}) {
    return math.max(min, size * _responsiveScale(context));
  }

  static const List<_TimelineEvent> _eventsDayOne = [
    _TimelineEvent(
      time: '២:០០ នាទីរសៀល',
      label: 'ពិធីសែនក្រុងពាលី',
      icon: Icons.people_rounded,
    ),
    _TimelineEvent(
      time: '៣:៣០ នាទីរសៀល',
      label: 'ពិធីសូត្រមន្តចម្រើនព្រះបរិត្ថ',
      icon: Icons.menu_book_rounded,
    ),
    _TimelineEvent(
      time: '៥:៣០ នាទីល្ងាច',
      label: 'អញ្ជើញភ្ញៀវកិត្តិយសពិសារអាហារពេលល្ងាច',
      icon: Icons.dinner_dining_rounded,
    ),
  ];

  static const List<_TimelineEvent> _events = [
    _TimelineEvent(
      time: '០៦:៣០ នាទីព្រឹក',
      label: 'ជួបជុំភ្ញៀវកិត្តិយសដើម្បីរៀបចំហែរជំនូន',
      icon: Icons.people_rounded,
    ),
    _TimelineEvent(
      time: '០៧:០០ នាទីព្រឹក',
      label: 'ពិធីកំណត់(ហែជំនូន) ចូលរោងជ័យ',
      icon: Icons.dinner_dining_rounded,
    ),
    _TimelineEvent(
      time: '០៧:៣០ នាទីព្រឹក',
      label: 'អញ្ជើញភ្ញៀវកិត្តិយសពិសារអាហារពេលព្រឹក',
      icon: Icons.dinner_dining_rounded,
    ),
    _TimelineEvent(
      time: 'ម៉ោង ០៨:០០ នាទីព្រឹក',
      label: 'ពិធីពិសាស្លាកំណត់ និងបំពាក់ចិញ្ចៀន',
      icon: Icons.favorite_rounded,
    ),
    _TimelineEvent(
      time: 'ម៉ោង ០៩:០០ នាទីព្រឹក',
      label: 'ពិធីកាត់សក់បង្កក់សេរី ចម្រើនកេសា',
      icon: Icons.content_cut_rounded,
    ),
    _TimelineEvent(
      time: 'ម៉ោង ១០:០០ នាទីព្រឹក',
      label: 'ពិធីបើកវាំងនន បង្វិលពពិល',
      icon: Icons.celebration_rounded,
    ),
    _TimelineEvent(
      time: 'ម៉ោង ១១:00 នាទីព្រឹក',
      label: 'ពិធីសំពះផ្ទឹម សែនចងដៃ ព្រះថោងនាងនាគ',
      icon: Icons.favorite_rounded,
    ),
    _TimelineEvent(
      time: '១២:០០ នាទីថ្ងៃត្រង់',
      label: 'អញ្ជើញភ្ញៀវកិត្តិយសពិសារអាហារថ្ងៃត្រង់',
      icon: Icons.dinner_dining_rounded,
    ),
    _TimelineEvent(
      time: '៥:០០ នាទីថ្ងៃល្ងាច',
      label:
          'ទទួលបដិសណ្ឋារកិច្ចភ្ញៀវកិត្តិយសពិសារភោជនាហារ ពេលល្ងាច ដោយមេត្រីភាព',
      icon: Icons.local_cafe_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _muted = BackgroundMusic.instance.isMuted;
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateCountdown(),
    );
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
        _seconds = 0;
      });
      return;
    }
    final diff = _eventDate.difference(now);
    setState(() {
      _days = diff.inDays;
      _hours = diff.inHours % 24;
      _minutes = diff.inMinutes % 60;
      _seconds = diff.inSeconds % 60;
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
    final end = start.add(const Duration(hours: 6));
    toUtc(DateTime d) => DateTime.utc(
      d.year,
      d.month,
      d.day,
      d.hour,
      d.minute,
      d.second,
    ).subtract(const Duration(hours: utcOffsetHours));
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

    final title = Uri.encodeComponent(
      'សិរីមង្គលអាពាហ៍ពិពាហ៍ អ៊ាង ចំណាប់ និង សន ណាន្ធីប',
    );
    final location = Uri.encodeComponent(
      'ភូមិសំរោងពក ឃុំអូតាប៉ោង ស្រុកបាកាន ខេត្តពោសាត់',
    );
    final details = Uri.encodeComponent(
      '២០ ខែមីនា ឆ្នាំ២០២៧ វេលាម៉ោង ០៥:០០ នាទីល្ងាច ស្ថិតនៅគេហដ្ឋានខាងស្រី ភូមិសំរោងពក ឃុំអូតាប៉ោង ស្រុកបាកាន ខេត្តពោសាត់',
    );
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
      _wishes.insert(
        0,
        _WishEntry(
          name: name,
          message: message,
          date: _formatDate(DateTime.now()),
        ),
      );
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
    final media = MediaQuery.sizeOf(context);
    final narrowColumn = kIsWeb || media.width > _maxInvitationContentWidth;

    Widget invitationStack() {
      return FallingParticles(
        particleCount: 24,
        particleType: ParticleType.heart,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  narrowColumn ? 48 : 56,
                  24,
                  narrowColumn ? 72 : 80,
                ),
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
                    const SizedBox(height: 200),
                    _buildContantThanks(),
                    const SizedBox(height: 200),
                    AnimateWhenVisible(
                      sectionKey: 'event_program',
                      visible: _visibleSections.contains('event_program'),
                      exiting: _exitingSections.contains('event_program'),
                      onVisible: () => _onSectionVisible('event_program'),
                      onNotVisible: () => _onSectionNotVisible('event_program'),
                      child: CustomKhmerTabBar(
                        initialIndex: _programTabIndex,
                        onTabChanged:
                            (i) => setState(() => _programTabIndex = i),
                        buildDayOne: (index) => buildProgramDayOne(),
                        buildDayTwo: (index) => buildProgramDayTwo(),
                      ),
                    ),

                    const SizedBox(height: 200),
                    AnimateWhenVisible(
                      sectionKey: 'ticket',
                      visible: _visibleSections.contains('ticket'),
                      exiting: _exitingSections.contains('ticket'),
                      onVisible: () => _onSectionVisible('ticket'),
                      onNotVisible: () => _onSectionNotVisible('ticket'),
                      child: _buildTicketSection(),
                    ),

                    const SizedBox(height: 200),
                    const ImageBlock(),
                    const SizedBox(height: 200),
                    AnimateWhenVisible(
                      sectionKey: 'location',
                      visible: _visibleSections.contains('location'),
                      exiting: _exitingSections.contains('location'),
                      onVisible: () => _onSectionVisible('location'),
                      onNotVisible: () => _onSectionNotVisible('location'),
                      child: _buildLocationSection(),
                    ),
                    const SizedBox(height: 200),
                    AnimateWhenVisible(
                      sectionKey: 'countdown',
                      visible: _visibleSections.contains('countdown'),
                      exiting: _exitingSections.contains('countdown'),
                      onVisible: () => _onSectionVisible('countdown'),
                      onNotVisible: () => _onSectionNotVisible('countdown'),
                      child: _buildCountdownSection(),
                    ),
                    const SizedBox(height: 200),
                    _buildQRCodeSection(),
                       const SizedBox(height: 200),
                    _buildThanksSection(),
                       const SizedBox(height: 200),
                       _buildCrediteSection()
                  ],
                ),
              ),

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
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (!narrowColumn) {
            return FloralFrame(child: invitationStack());
          }
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: math.min(
                  constraints.maxWidth,
                  _maxInvitationContentWidth,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: constraints.maxHeight,
                child: FloralFrame(child: invitationStack()),
              ),
            ),
          );
        },
      ),
    );
  }

  static const String _bannerAsset =
      'assets/images/khmer_text_color_6B4E9E 1.svg';

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
    final horizontalPadding = _responsiveScale(context) < 0.9 ? 44.0 : 80.0;
    return GestureDetector(
      onTap: () => _openImageViewer(context, _bannerAsset),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        child: Image.asset(
              'assets/images/khmer_text_color_6B4E9E 1.png',
              fit: BoxFit.cover,
            )
            .animate()
            .fadeIn(duration: 50.ms, delay: 100.ms, curve: Curves.easeOutCubic)
            .scale(
              begin: const Offset(0.92, 0.92),
              end: const Offset(1, 1),
              duration: 400.ms,
              delay: 50.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }

  Widget _buildContantThanks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.lavender.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
                'សេចក្តីថ្លែងអំណរគុណ​ និង \nសូមអភ័យទោស',
                textAlign: TextAlign.center,
                style: GoogleFonts.moul(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                  height: 1.3,
                ),
              )
              .animate()
              .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
              .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 20),
          const Divider(color: AppTheme.primaryPurple, height: 2),
          const SizedBox(height: 20),
          const Text(
            'យើងខ្ញុំសូមថ្លែងអំណរគុណយ៉ាងជ្រាលជ្រៅចំពោះការអញ្ជើញចូលរួមជា​ ភ្ញៀវកិត្តិយសក្នុងពីធីរៀបអាពាហ៍ពិពាហ៍ របស់យើងខ្ញុំ និងសូមខន្តីអភ័យទោស ដោយពុំបានជួបអញ្ជើញដោយផ្ទាល់ និងការសរសេរឈ្មោះរបស់ភ្ញៀវកិត្តិយសមិនបានត្រឹមត្រូវ ឬ ពុំបានសរសេរឈ្មោះ។\n',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.primaryPurple,
              height: 1.5,
              fontFamily: 'BattambangRegular',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'សូមគោរពជូនពរ ឯកឧត្តម  លោកអ្នកឧកញ៉ា អ្នកឧកញ៉ា ឧកញ៉ា​  លោកជំទាវ លោក លោកស្រី អ្នកនាង កញ្ញា និងភ្ញៀវកិត្តិយសទាំងអស់មានសុខភាពល្អ និងទទួលបានជោគជ័យគ្រប់ភារកិច្ច។ សូមអរគុណ !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.primaryPurple,
              height: 1.5,
              fontFamily: 'BattambangRegular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfoAndCalendar() {
    final titleSize = _responsiveFont(context, 18, min: 15);
    final bodySize = _responsiveFont(context, 16, min: 14);
    final namesSpacing = _responsiveScale(context) < 0.9 ? 12.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: namesSpacing,
              runSpacing: 12,
              children: [
                customName(context, 'អ៊ុត នាង', 'យិន ស៊ិ'),
                customName(context, 'សន សល់', 'ហឿន គុន្ធី'),
              ],
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 20),
        Text(
          'យើងខ្ញុំមានកិត្តិយសសូមគោរពអញ្ជើញ',
          textAlign: TextAlign.center,
          style: GoogleFonts.moul(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 20),
        Text(
              'សម្ដេច ទ្រង់ ឯកឧត្ដម លោកអ្នកឧកញ៉ា អ្នកឧកញ៉ា ឧកញ៉ា លោកជំទាវ លោក លោកស្រី អ្នកនាង កញ្ញា និងប្រិយមិត្ត អញ្ជើញចូលរួមជាភ្ញៀវកិត្តិយស ដើម្បីប្រសិទ្ធពរជ័យ សិរីសួស្ដី ជ័យមង្គលក្នុងពិធីសិរីមង្គលអាពាហ៍ពិពាហ៍កូនប្រុស កូនស្រីរបស់យើងខ្ញុំ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: bodySize,
                color: AppTheme.primaryPurple,
                height: 1.5,
                fontFamily: 'BattambangRegular',
              ),
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 20),
        Image.asset('assets/images/logo_name.png', width: 120, height: 120),
        const SizedBox(height: 20),
        Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: namesSpacing,
              runSpacing: 20,
              children: [
                nameLove(context, 'កូនប្រុសនាម', 'អ៊ាង ចំណាប់'),

                nameLove(context, 'កូនស្រីនាម', 'សន ណាន្ធីប'),
              ],
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 40),
        KhmerCardWidget(titleFont: _responsiveFont(context, 20, min: 18)),
        const SizedBox(height: 40),
        Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'ថ្ងៃ',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: AppTheme.primaryPurple,
                      height: 1.5,
                      fontFamily: 'BattambangRegular',
                    ),
                  ),
                  TextSpan(
                    text:
                        'សៅរ៍ ១៣កើត ខែផល្គុន ឆ្នាំមមី អដ្ឋស័ក ពុទ្ធសករាជ ២៥៧០',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                      height: 1.5,
                      fontFamily: 'BattambangRegular',
                    ),
                  ),
                  TextSpan(
                    text: ' ត្រូវនឹង\nថ្ងៃទី',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: AppTheme.primaryPurple,
                      height: 1.5,
                      fontFamily: 'BattambangRegular',
                    ),
                  ),
                  TextSpan(
                    text:
                        '២០ ខែមីនា ឆ្នាំ២០២៧ វេលាម៉ោង ០៥:០០ នាទីល្ងាច\n ស្ថិតនៅគេហដ្ឋានខាងស្រី ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                      height: 1.5,
                      fontFamily: 'BattambangRegular',
                    ),
                  ),
                  TextSpan(
                    text: ' ដោយមេត្រីភាព។ សូមអរគុណ!',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: AppTheme.primaryPurple,
                      height: 1.5,
                      fontFamily: 'BattambangRegular',
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 40),
        Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _addToCalendar,
                child: Image.asset('assets/images/Component.png', height: 70),
              ),
            )
            .animate(
              delay: 1050.ms,
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .moveY(
              begin: 0,
              end: -10,
              duration: 900.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }

  Widget buildProgramDayTwo() {
    final subheadingSize = _responsiveFont(context, 18, min: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
              'ថ្ងៃសៅរ៍ ទី២០ ខែមីនា ឆ្នាំ២០២៧',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subheadingSize,
                fontFamily: 'KHMEROSMUOLLIGHT',
                color: AppTheme.primaryPurple,
              ),
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.03, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 30),
        ...List.generate(_events.length, (i) {
          final event = _events[i];
          final isLast = i == _events.length - 1;
          return _TimelineRow(event: event, isLast: isLast, index: i);
        }),
      ],
    );
  }

  Widget buildProgramDayOne() {
    final subheadingSize = _responsiveFont(context, 18, min: 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
              'ថ្ងៃសុក្រ ទី១៩ ខែមីនា ឆ្នាំ២០២៧',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: subheadingSize,
                fontFamily: 'KHMEROSMUOLLIGHT',
                color: AppTheme.primaryPurple,
              ),
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.03, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 30),
        ...List.generate(_eventsDayOne.length, (i) {
          final event = _eventsDayOne[i];
          final isLast = i == _eventsDayOne.length - 1;
          return _TimelineRow(event: event, isLast: isLast, index: i);
        }),
      ],
    );
  }

  Widget customName(
    BuildContext context,
    String fatherName,
    String motherName,
  ) {
    final prefixSize = _responsiveFont(context, 16, min: 13);
    final fatherSize = _responsiveFont(context, 20, min: 16);
    final motherSize = _responsiveFont(context, 18, min: 15);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'លោក ',
                style: TextStyle(
                  fontSize: prefixSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.namePurple,
                  height: 1.3,
                  fontFamily: 'BattambangBold',
                ),
              ),
              TextSpan(
                text: fatherName,
                style: GoogleFonts.moul(
                  fontSize: fatherSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'លោកស្រី ',
                style: TextStyle(
                  fontSize: prefixSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.namePurple,
                  height: 1.3,
                  fontFamily: 'BattambangBold',
                ),
              ),
              TextSpan(
                text: motherName,
                style: GoogleFonts.moul(
                  fontSize: motherSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget nameLove(BuildContext context, String title, String name) {
    final prefixSize = _responsiveFont(context, 16, min: 13);
    final nameSize = _responsiveFont(context, 20, min: 16);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: prefixSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.namePurple,
            height: 1.3,
            fontFamily: 'BattambangBold',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.moul(
            fontSize: nameSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketSection() {
    final titleSize = _responsiveFont(context, 20, min: 17);
    final ticket = WeddingTicket(
      ticketId: 'WN-2026-0028',
      guestName: widget.guestName ?? 'លោក-ទេពសត្យា',
      eventName: 'សិរីមង្គលអាពាហ៍ពិពាហ៍',
      eventDate: 'ថ្ងៃសៅរ៍ ទី២០ ខែមីនា ឆ្នាំ២០២៧',
      location: 'ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
      guestsCount: 1,
      tableNumber: '៥',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
              'សំបុត្ររបស់ខ្ញុំ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'KHMEROSMUOLLIGHT',
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            )
            .animate()
            .fadeIn(duration: 440.ms, curve: Curves.easeOutCubic)
            .slideY(begin: -0.025, end: 0, curve: Curves.easeOutCubic),
        const SizedBox(height: 30),
        Center(child: WeddingTicketCard(ticket: ticket, animate: true)),
      ],
    );
  }

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
            child: Icon(
              Icons.photo_library_rounded,
              size: 48,
              color: AppTheme.primaryPurple.withOpacity(0.5),
            ),
          ),
        )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: animationDelayMs.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: animationDelayMs.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// Gallery: 2 images (animationDelay) → 1 big image → vertical list (scroll up).

  Widget _buildGalleryImageCard(
    String? asset,
    int delayMs,
    double height, {
    bool isBig = false,
  }) {
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
        .slideY(
          begin: 0.06,
          end: 0,
          duration: 440.ms,
          delay: delayMs.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 440.ms,
          delay: delayMs.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// List image: animates when user scrolls and the item meets the viewport.
  Widget _buildGalleryListImageCard(
    String asset,
    double height, {
    required bool visible,
  }) {
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
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 420.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          duration: 420.ms,
          curve: Curves.easeOutCubic,
        );
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
        child:
            asset != null
                ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => _buildGalleryPlaceholder(
                            animationDelayMs: placeholderDelayMs,
                          ),
                    ),
                    Positioned.fill(
                      child: FallingParticles(
                        particleCount: isBig ? 18 : 12,
                        particleType:
                            isBig ? ParticleType.heart : ParticleType.petal,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                )
                : _buildGalleryPlaceholder(
                  animationDelayMs: placeholderDelayMs,
                ),
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
    final bodySize = _responsiveFont(context, 14, min: 12);

    return Column(
      children: [
        const Icon(
          Icons.location_on_rounded,
          color: AppTheme.primaryPurple,
          size: 50,
        ),

        const SizedBox(height: 20),
        const Text(
          'ទីតាំងកម្មវិធី',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'KHMEROSMUOLLIGHT',
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'ពិធីមង្គលការ និង ពិសាភោជនាហារ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'BattambangRegular',
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'ភូមិសំរោងពក  ចង្ងាយ 200m ពីសាលាបឋមសិក្សាសំរោងពក',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'BattambangRegular',
            fontWeight: FontWeight.bold,
            color: AppTheme.deepPurple,
          ),
        ),
        const SizedBox(height: 40),
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
              const LocationQrCode(size: 200),
              const SizedBox(height: 12),
              Text(
                'ស្កែនឬចុចដើម្បីមើលទីតាំង',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: bodySize, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _addToCalendar,
                child: Image.asset('assets/images/location.png', height: 70),
              ),
            )
            .animate(
              delay: 1050.ms,
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .moveY(
              begin: 0,
              end: -10,
              duration: 900.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }

  Widget _buildCountdownSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset('assets/images/icon_date.png', width: 70, height: 70),
        const SizedBox(height: 40),
        Image.asset('assets/images/savedate.png', height: 110),
        const SizedBox(height: 40),
        const Text(
          'ថ្ងៃសៅរ៍ ទី២០ ខែមីនា ឆ្នាំ២០២៧',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryPurple,
            fontFamily: 'KHMEROSMUOLLIGHT',
          ),
        ),
        const SizedBox(height: 20),
        StatisticScreen(
          day: _days,
          hour: _hours,
          minute: _minutes,
          second: _seconds,
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(
          'assets/images/iconQR.png',
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        const Text(
          'ស្កេន QR CODE',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'KHMEROSMUOLLIGHT',
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          textAlign: TextAlign.center,
          'ភ្ញៀវកិត្តិយស ក៏អាចផ្ញើចំណងដៃតាមរយគណនី QR CODE របស់យើងខ្ញុំនៅខាងក្រោមនេះ',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryPurple,
            fontFamily: 'BattambangRegular',
          ),
        ),
        const SizedBox(height: 30),
        Image.asset(
          'assets/images/qrcode.jpg',
          width: 400,
          height: 400,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
  
  Widget _buildThanksSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(
          'assets/images/iconTanks.png',
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        const Text(
          'សូមថ្លែងអំណរគុណ',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'KHMEROSMUOLLIGHT',
          ),
        ),
        const SizedBox(height: 20),
        
        // add your content here, for example a thank you message or any other widgetសម្អាងការ

// ណុប ដាណេ សម្អាងការ - Nob Dane SamAngkar

// ជាងថតរូប / វីដេអូ

// One Memory

// បទចំរៀងម្ចាស់ដើម

// ថ្ងៃដែលរង់ចាំ - ថុល សុភិទ

        const SizedBox(height: 30),
       
      ],
    );
  }
  
  Widget _buildCrediteSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'បង្កើតដោយ',
          style: TextStyle(
            fontSize: 18,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'KHMEROSMUOLLIGHT',
          ),
        ),
       
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/LOGONANA-removebg-preview.png',
          fit: BoxFit.cover,
        )
       
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
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child:
                    asset.toLowerCase().endsWith('.svg')
                        ? SvgPicture.asset(asset, fit: BoxFit.contain)
                        : Image.asset(
                          asset,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  size: 64,
                                  color: Colors.white54,
                                ),
                              ),
                        ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
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
  const _TimelineRow({
    required this.event,
    required this.isLast,
    required this.index,
  });
  final _TimelineEvent event;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scale = (math.min(MediaQuery.sizeOf(context).width, 430) / 430).clamp(
      0.82,
      1.0,
    );
    final timeSize = math.max(18.0, 14 * scale);
    final labelSize = math.max(18.0, 14 * scale);

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
                          border: Border.all(
                            color: AppTheme.primaryPurple,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          event.icon,
                          size: 18,
                          color: AppTheme.primaryPurple,
                        ),
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
                        style: TextStyle(
                          fontSize: timeSize,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.label,
                        style: TextStyle(
                          fontSize: labelSize,
                          color: AppTheme.primaryPurple,
                          height: 1.5,
                          fontFamily: 'BattambangRegular',
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
        .fadeIn(
          duration: 440.ms,
          delay: (55 * index).ms,
          curve: Curves.easeOutCubic,
        )
        .slideX(
          begin: 0.02,
          end: 0,
          curve: Curves.easeOutCubic,
          delay: (55 * index).ms,
        );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final scale = (math.min(MediaQuery.sizeOf(context).width, 430) / 430).clamp(
      0.82,
      1.0,
    );
    final cardWidth = math.max(72.0, 88 * scale);
    final valueSize = math.max(22.0, 28 * scale);
    final labelSize = math.max(11.0, 13 * scale);

    return Container(
      width: cardWidth,
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
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: labelSize, color: AppTheme.textMuted),
          ),
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
