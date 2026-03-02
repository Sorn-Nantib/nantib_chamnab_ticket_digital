import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';
import '../widgets/floral_frame.dart';
import 'welcome_ticket_screen.dart';

/// First screen: Admin inputs guest name and copies link to send.
/// When user opens link with ?guest=Name, they go straight to welcome with that name.
class GuestNameScreen extends StatefulWidget {
  const GuestNameScreen({super.key});

  @override
  State<GuestNameScreen> createState() => _GuestNameScreenState();
}

class _GuestNameScreenState extends State<GuestNameScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkGuestFromUrl());
  }

  void _checkGuestFromUrl() {
    if (!kIsWeb || !mounted) return;
    final uri = Uri.base;
    final guest = uri.queryParameters['guest'];
    if (guest != null && guest.trim().isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => WelcomeTicketScreen(guestName: guest.trim()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _buildInviteLink(String name) {
    if (name.trim().isEmpty) return '';
    if (kIsWeb) {
      final u = Uri.base;
      final path = u.path.isEmpty ? '/' : u.path;
      return '${u.origin}$path?guest=${Uri.encodeComponent(name.trim())}';
    }
    return '?guest=${Uri.encodeComponent(name.trim())}';
  }

  Future<void> _copyLink() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('បញ្ចូលឈ្មោះភ្ញៀវជាមុន')),
        );
      }
      return;
    }
    final link = _buildInviteLink(name);
    await Clipboard.setData(ClipboardData(text: link));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ចម្លងភ្ជាប់រួចរាល់')),
      );
    }
  }

  void _previewWelcome() {
    final name = _controller.text.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => WelcomeTicketScreen(guestName: name.isEmpty ? null : name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloralFrame(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'សិរីមង្គលអាពាហ៍ពិពាហ៍',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.deepPurple,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  kIsWeb ? 'វាយឈ្មោះភ្ញៀវ រួចចម្លងភ្ជាប់ផ្ញើជូន' : 'វាយឈ្មោះភ្ញៀវ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 28),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ឈ្មោះភ្ញៀវ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'បញ្ចូលឈ្មោះភ្ញៀវ',
                    hintStyle: TextStyle(color: AppTheme.textMuted.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.lightLavender),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryPurple.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                  onSubmitted: (_) => _copyLink(),
                ),
                const SizedBox(height: 24),
                if (kIsWeb) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _copyLink,
                      icon: const Icon(Icons.link_rounded, size: 20),
                      label: const Text('ចម្លងភ្ជាប់ផ្ញើជូនភ្ញៀវ'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _previewWelcome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.deepPurple,
                      side: const BorderSide(color: AppTheme.primaryPurple),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('មើលមុន'),
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
