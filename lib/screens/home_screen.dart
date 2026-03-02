import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../models/wedding_ticket.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';
import '../widgets/wedding_ticket_card.dart';

// Home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final List<_WishEntry> _wishes = [
    _WishEntry(name: 'Theshy', message: '恭喜百年!', date: '20/03/2027, 15:50'),
    _WishEntry(name: 'Ramos', message: '新婚快乐 永结同心祝愿', date: '20/03/2027, 16:10'),
    _WishEntry(name: '拉莫斯', message: '愿幸福', date: '30/12/2025, 15:50'),
  ];
  static final DateTime _eventDate = DateTime(2027, 3, 20, 7, 0);
  int _days = 0, _hours = 0, _minutes = 0;
  Timer? _timer;

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
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
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
    return Scaffold(
      body: FloralFrame(
        child: FallingParticles(
          particleCount: 22,
          particleType: ParticleType.heart,
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 48),
                      _buildTicketSection(),
                      const SizedBox(height: 48),
                      _buildTimelineSection(),
                      const SizedBox(height: 48),
                      _buildWishesSection(),
                      const SizedBox(height: 48),
                      _buildLocationSection(),
                    ],
                  ),
                ),
                Positioned(top: 12, right: 16, child: LanguageButton(onTap: () {})),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
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
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.08, end: 0, curve: Curves.easeOut),
        const SizedBox(height: 12),
        const Text(
          'ថ្ងៃពុធ ទី២៨ ខែមករា ឆ្នាំ២០២៦',
          style: TextStyle(fontSize: 15, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
        ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
        const SizedBox(height: 20),
        const Text(
          'លោក Yong Xing  និង អ្នកស្រី Xiao Ping\nលោក វ៉ាន់ សាវុធ និង អ្នកស្រី យ៉េង គា',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppTheme.textDark, height: 1.5),
        ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
        const SizedBox(height: 16),
        const Text(
          'សូមគោរពអញ្ជើញ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryPurple),
        ).animate().fadeIn(duration: 400.ms, delay: 160.ms),
        const SizedBox(height: 24),
        const Text(
          'កូនប្រុស xiao zhi  ជាគូនឹង  កូនស្រី xiao mei',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepPurple),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        const SizedBox(height: 16),
        const Text(
          'ដែលនឹងប្រព្រឹត្តទៅនៅ\nភូមិដើមចារ ឃុំកំពង់ត្រាចខាងលិច',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
        ).animate().fadeIn(duration: 400.ms, delay: 240.ms),
      ],
    );
  }

  static const WeddingTicket _sampleTicket = WeddingTicket(
    ticketId: 'WN-2026-0028',
    guestName: 'លោក-ទេពសត្យា',
    eventName: 'សិរីមង្គលអាពាហ៍ពិពាហ៍',
    eventDate: 'ថ្ងៃពុធ ទី២៨ ខែមករា ឆ្នាំ២០២៦',
    location: 'ភូមិសំរោងពក ឃុំអូតាប៉ោង\nស្រុកបាកាន ខេត្តពោសាត់',
    guestsCount: 1,
    tableNumber: '៥',
  );

  Widget _buildTicketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'សំបុត្ររបស់ខ្ញុំ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepPurple,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.03, end: 0, curve: Curves.easeOut),
        const SizedBox(height: 16),
        const Center(
          child: WeddingTicketCard(
            ticket: _sampleTicket,
            animate: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'កម្មវិធីពេលព្រឹក',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepPurple,
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.03, end: 0, curve: Curves.easeOut),
        const SizedBox(height: 20),
        ...List.generate(_events.length, (i) {
          final event = _events[i];
          final isLast = i == _events.length - 1;
          return _TimelineRow(event: event, isLast: isLast, index: i);
        }),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepPurple,
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.03, end: 0, curve: Curves.easeOut),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepPurple,
          ),
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
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Text('QR Code', style: TextStyle(color: Colors.grey.shade600)),
              ),
              const SizedBox(height: 12),
              const Text(
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
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
        .fadeIn(duration: 400.ms, delay: (60 * index).ms)
        .slideX(begin: 0.03, end: 0, curve: Curves.easeOut, delay: (60 * index).ms);
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
