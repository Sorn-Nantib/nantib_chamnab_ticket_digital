import 'package:flutter/material.dart';
import 'package:nantib_chamnab_ticket_digital/app_theme.dart';

class KhmerCardWidget extends StatelessWidget {
  final double? titleFont;
  const KhmerCardWidget({super.key, this.titleFont});
  static const TextStyle bodySize = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryPurple,
    height: 1.3,
    fontFamily: 'KHMEROSMUOLLIGHT',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TOP TITLE

          /// CENTER CONTENT
          Row(
            children: [
              /// LEFT
              Expanded(
                child: Column(
                  children: [
                    divedercustom(),
                 const   SizedBox(width: 10),
                    Text('ថ្ងៃសៅរ៍', style: bodySize.copyWith(fontSize: titleFont ?? 20)),
                 const   SizedBox(width: 10),
                    divedercustom(),
                  ],
                ),
              ),

              /// CENTER NUMBER
              Column(
                children: [
                   Text('ខែមីនា',style: bodySize.copyWith(fontSize: titleFont ?? 20)),
                  const SizedBox(height: 20),
                  Text('២០', style: bodySize.copyWith(fontSize: 32)),
                  const SizedBox(height: 20),
                   Text('២០២៧',style: bodySize.copyWith(fontSize: titleFont ?? 20)),
                ],
              ),

              /// RIGHT
              Expanded(
                child: Column(
                  children: [
                    divedercustom(),
                    const SizedBox(width: 10),
                     Text('ម៉ោង៥ល្ងាច', style: bodySize.copyWith(fontSize: titleFont ?? 20)),
                    const SizedBox(width: 10),
                    divedercustom(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget divedercustom() {
  return const Divider(color: AppTheme.primaryPurple, thickness: 2);
}
