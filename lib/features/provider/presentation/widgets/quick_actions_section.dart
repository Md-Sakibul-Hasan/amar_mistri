import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../bloc/provider_bookings_bloc.dart';
import '../pages/provider_all_bookings_page.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  static const _actions = [
    ('Bookings', '📅', Color(0xFFE8F0FE), Color(0xFF1A73E8)),
    ('Earnings', '💰', Color(0xFFDCFCE7), Color(0xFF22C55E)),
    ('Reviews', '⭐', Color(0xFFFEF9C3), Color(0xFFCA8A04)),
    ('Profile', '👤', Color(0xFFFCE7F3), Color(0xFFEC4899)),
    ('Schedule', '🗓️', Color(0xFFEDE9FE), Color(0xFF7C3AED)),
    ('Support', '💬', Color(0xFFFFEDD5), Color(0xFFEA580C)),
  ];

  void _onTap(BuildContext context, String label) {
    switch (label) {
      case 'Bookings':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<ProviderBookingsBloc>(),
              child: const ProviderAllBookingsPage(),
            ),
          ),
        );
      case 'Profile':
        context.push(AppRouter.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right, size: 14, color: Color(0xFF1A73E8)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _actions.length,
          itemBuilder: (_, i) {
            final (label, emoji, bg, fg) = _actions[i];
            return GestureDetector(
              onTap: () => _onTap(context, label),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
