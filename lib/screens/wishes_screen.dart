import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_theme.dart';
import '../widgets/falling_particles.dart';
import '../widgets/floral_frame.dart';
import '../widgets/language_button.dart';

class WishesScreen extends StatefulWidget {
  const WishesScreen({super.key});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final List<_WishEntry> _wishes = [
    _WishEntry(name: 'Theshy', message: '恭喜百年!', date: '30/12/2025, 15:50'),
    _WishEntry(name: 'Ramos', message: '新婚快乐 永结同心祝愿', date: '30/12/2025, 16:10'),
    _WishEntry(name: '拉莫斯', message: '愿幸福', date: '30/12/2025, 15:50'),
  ];

  @override
  void dispose() {
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
          particleType: ParticleType.heart,
          particleCount: 22,
          child: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
                        child: Column(
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
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOut),
                            const SizedBox(height: 20),
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
                                  ).animate().fadeIn(duration: 350.ms, delay: 80.ms),
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
                                  ).animate().fadeIn(duration: 350.ms, delay: 120.ms),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: _sendWish,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppTheme.primaryPurple,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('ផ្ញើ'),
                                    ),
                                  ).animate().fadeIn(duration: 350.ms, delay: 160.ms),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'សារជូនពរ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepPurple,
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
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
                                      Text(
                                        '${w.name}:',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textDark,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        w.message,
                                        style: const TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        w.date,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 350.ms, delay: (240 + i * 60).ms)
                                  .slideX(begin: 0.03, end: 0, curve: Curves.easeOut, delay: (240 + i * 60).ms);
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

class _WishEntry {
  _WishEntry({required this.name, required this.message, required this.date});
  final String name;
  final String message;
  final String date;
}
