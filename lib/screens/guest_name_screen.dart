import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/floral_frame.dart';
import 'welcome_ticket_screen.dart';

/// First screen: input guest name (ភ្ញៀវ) then go to welcome with that name.
class GuestNameScreen extends StatefulWidget {
  const GuestNameScreen({super.key});

  @override
  State<GuestNameScreen> createState() => _GuestNameScreenState();
}

class _GuestNameScreenState extends State<GuestNameScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _continueToWelcome() {
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
                const SizedBox(height: 32),
                const Text(
                  'ឈ្មោះភ្ញៀវ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
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
                  onSubmitted: (_) => _continueToWelcome(),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _continueToWelcome,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('ចាប់ផ្តើម'),
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
