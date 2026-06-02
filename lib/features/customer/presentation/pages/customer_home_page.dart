import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/greeting_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/categories_section.dart';
import '../widgets/home_header.dart';
import '../widgets/how_it_works_section.dart';
import 'customer_booking_list_page.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();
    final firstName = authState.user.name.split(' ').first;
    final imageUrl = authState.user.photoUrl;

    return Scaffold(
      backgroundColor: context.colors.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(greeting: getGreeting(context.l10n), firstName: firstName, photoUrl: imageUrl),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // const BannerCarousel(),
                  const SizedBox(height: 5),
                  _MyBookingsEntry(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CustomerBookingListPage()));
                    },
                  ),
                  const SizedBox(height: 20),
                  const CategoriesSection(),
                  // const SizedBox(height: 20),
                  // const TopProvidersSection(),
                  const SizedBox(height: 20),
                  const HowItWorksSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyBookingsEntry extends StatelessWidget {
  final VoidCallback onTap;

  const _MyBookingsEntry({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: c.shadowMedium, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: c.lightBlueBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF1A73E8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.myBookings,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.primaryText),
                  ),
                  const SizedBox(height: 3),
                  Text(context.l10n.myBookingsSubtitle, style: TextStyle(fontSize: 12, color: c.secondaryText)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF1A73E8)),
          ],
        ),
      ),
    );
  }
}
