import 'package:flutter/material.dart';

class TipsSection extends StatelessWidget {
  const TipsSection({super.key});

  static const _steps = [
    ('Stay Online', '📡'),
    ('Respond Fast', '⚡'),
    ('Earn More!', '💸'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips to Earn More',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                return const Expanded(
                  child: Divider(
                    color: Color(0xFFE8F0FE),
                    thickness: 2,
                    height: 2,
                  ),
                );
              }
              final s = _steps[i ~/ 2];
              return Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(s.$2, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.$1,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
