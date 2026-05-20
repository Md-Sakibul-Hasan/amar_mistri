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
    ('Reviews', '⭐', Color(0xFFFEF9C3), Color(0xFFCA8A04)),
    ('Profile', '👤', Color(0xFFFCE7F3), Color(0xFFEC4899)),
  ];

  // Darker tinted backgrounds for dark mode
  static const _darkBgs = [
    Color(0xFF1A2744), // Bookings
    Color(0xFF2A270E), // Reviews
    Color(0xFF2D1020), // Profile
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final titleColor = isDark
        ? const Color(0xFFE2E2F0)
        : const Color(0xFF1A1A2E);
    final shadowColor = Colors.black.withAlpha(isDark ? 40 : 10);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            // TextButton(
            //   onPressed: () {},
            //   style: TextButton.styleFrom(
            //     minimumSize: Size.zero,
            //     padding: const EdgeInsets.symmetric(horizontal: 4),
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   child: const Row(
            //     children: [
            //       Text(
            //         'See all',
            //         style: TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.w600,
            //           color: Color(0xFF1A73E8),
            //         ),
            //       ),
            //       SizedBox(width: 2),
            //       Icon(Icons.chevron_right, size: 14, color: Color(0xFF1A73E8)),
            //     ],
            //   ),
            // ),
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
            final (label, emoji, _, fg) = _actions[i];
            final bg = isDark ? _darkBgs[i] : _actions[i].$3;
            return GestureDetector(
              onTap: () => _onTap(context, label),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
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
