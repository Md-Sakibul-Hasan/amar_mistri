import 'package:flutter/material.dart';

class ProviderStatsRow extends StatelessWidget {
  final dynamic user;

  const ProviderStatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        label: 'Total Jobs',
        value: '0',
        icon: Icons.handyman_outlined,
        color: const Color(0xFF1A73E8),
        bg: const Color(0xFFE8F0FE),
      ),
      (
        label: 'This Month',
        value: '৳0',
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFF22C55E),
        bg: const Color(0xFFDCFCE7),
      ),
      (
        label: 'Rating',
        value: '—',
        icon: Icons.star_rounded,
        color: const Color(0xFFFACC15),
        bg: const Color(0xFFFEF9C3),
      ),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s == stats.last ? 0 : 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s.label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
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
