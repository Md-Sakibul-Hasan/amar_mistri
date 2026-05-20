import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _steps = [
    ('Pick Service', '🔍'),
    ('Choose Pro', '👷'),
    ('Book & Done!', '✅'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: c.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Amar Mistri Works',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: c.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Expanded(
                  child: Divider(color: c.lightBlueBg, thickness: 2, height: 2),
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
                        color: c.lightBlueBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(s.$2, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.$1,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: c.primaryText,
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
