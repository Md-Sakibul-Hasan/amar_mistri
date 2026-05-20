import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProviderStatsRow extends StatelessWidget {
  final dynamic user;

  const ProviderStatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stats = [
      (
        label: 'Total Jobs',
        value: '0',
        icon: Icons.handyman_outlined,
        color: const Color(0xFF1A73E8),
        bg: c.lightBlueBg,
      ),
      (
        label: 'This Month',
        value: '৳0',
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFF22C55E),
        bg: c.lightGreenBg,
      ),
      (
        label: 'Rating',
        value: '—',
        icon: Icons.star_rounded,
        color: const Color(0xFFFACC15),
        bg: c.lightYellowBg,
      ),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s == stats.last ? 0 : 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: c.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: s.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(s.icon, size: 18, color: s.color),
                ),
                const SizedBox(height: 6),
                Text(
                  s.value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: c.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.label,
                  style: TextStyle(fontSize: 10, color: c.greyText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
