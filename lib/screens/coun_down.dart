import 'package:flutter/material.dart';
import 'package:nantib_chamnab_ticket_digital/app_theme.dart';

class StatisticScreen extends StatelessWidget {
  final int day;
  final int hour;
  final int minute;
  final int second;
  const StatisticScreen({
    super.key,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: AppTheme.lavender, width: 16),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "រាប់ថយក្រោយ",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'KHMEROSMUOLLIGHT',
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),

            const SizedBox(height: 30),

            _buildTotalCard(),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(child: SmallCard(title: "ម៉ោង", value: "$hour")),

                const SizedBox(width: 14),

                Expanded(child: SmallCard(title: "នាទី", value: "$minute")),

                const SizedBox(width: 14),

                Expanded(child: SmallCard(title: "វិនាទី", value: "$second")),
              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "អរគុណដែលបានចូលរួម",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'KHMEROSMUOLLIGHT',
                fontSize: 18,
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "ជួបគ្នាឆាប់ៗ 🎉",
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryPurple,
                fontFamily: 'KHMEROSMUOLLIGHT',
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        border: Border.all(color: AppTheme.lavender, width: 4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "$day",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.cardWhite,
                  fontFamily: 'KHMEROSMUOLLIGHT',
                ),
              ),
            ),
          ),
          const Divider(height: 2, color: AppTheme.cardWhite),
          Container(
            height: 70,
            alignment: Alignment.center,
            child: const Text(
              "ថ្ងៃ",
              style: TextStyle(
                color: AppTheme.lightLavender,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'KHMEROSMUOLLIGHT',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final String title;
  final String value;

  const SmallCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lavender, width: 4),
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'KHMEROSMUOLLIGHT',
                  color: AppTheme.cardWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(height: 2, color: AppTheme.cardWhite),
          Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'KHMEROSMUOLLIGHT',
                color: AppTheme.lightLavender,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
