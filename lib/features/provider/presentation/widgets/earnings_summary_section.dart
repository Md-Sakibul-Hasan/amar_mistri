import 'package:flutter/material.dart';

class EarningsSummarySection extends StatelessWidget {
  const EarningsSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A73E8), Color(0xFF00A2D2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A73E8).withAlpha(60),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings Overview',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'April 2026',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '৳0.00',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Total earnings this month',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _EarningChip(label: 'Jobs Done', value: '0'),
              SizedBox(width: 12),
              _EarningChip(label: 'Avg/Job', value: '৳0'),
              SizedBox(width: 12),
              _EarningChip(label: 'Pending', value: '৳0'),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarningChip extends StatelessWidget {
  final String label;
  final String value;

  const _EarningChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
