import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/greeting_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/provider_bookings_bloc.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_bookings_section.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();
    final user = authState.user;
    final firstName = user.name.split(' ').first;

    return BlocProvider<ProviderBookingsBloc>(
      create: (_) => sl<ProviderBookingsBloc>()..add(ProviderBookingsRequested(user.uid)),
      child: Scaffold(
        backgroundColor: context.colors.scaffoldBg,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ProviderHeader(
                  greeting: getGreeting(context.l10n),
                  firstName: firstName,
                  serviceArea: user.serviceArea,
                  photoUrl: user.photoUrl,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _StatsRow(user: user),
                    const SizedBox(height: 20),
                    const QuickActionsSection(),
                    const SizedBox(height: 20),
                    const RecentBookingsSection(),
                    const SizedBox(height: 20),
                    const _EarningsSummarySection(),
                    const SizedBox(height: 20),
                    const _TipsSection(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _ProviderHeader extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String? photoUrl;
  final String? serviceArea;

  const _ProviderHeader({required this.greeting, required this.firstName, this.serviceArea, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A73E8), Color(0xFF00A2D2)]),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Avatar + greeting
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                          child: photoUrl == null
                              ? Text(
                                  firstName[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 13, color: Colors.white70),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      serviceArea ?? context.l10n.setServiceArea,
                                      style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$greeting, $firstName! 👷',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification bell
                  // Stack(
                  //   children: [
                  //     Container(
                  //       width: 36,
                  //       height: 36,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white24,
                  //         borderRadius: BorderRadius.circular(18),
                  //       ),
                  //       child: const Icon(
                  //         Icons.notifications_outlined,
                  //         size: 18,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 0,
                  //       right: 0,
                  //       child: Container(
                  //         width: 16,
                  //         height: 16,
                  //         decoration: const BoxDecoration(
                  //           color: Color(0xFFEF4444),
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: const Center(
                  //           child: Text(
                  //             '2',
                  //             style: TextStyle(
                  //               fontSize: 9,
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(width: 8),
                  // Three-dot menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                    color: context.colors.cardBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'profile') {
                        context.push(AppRouter.profile);
                      } else if (value == 'theme') {
                        context.read<ThemeCubit>().toggle();
                      } else if (value == 'language') {
                        _showLanguageDialog(context);
                      } else if (value == 'logout') {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Text(
                              context.l10n.logout,
                              style: TextStyle(fontWeight: FontWeight.w800, color: context.colors.primaryText),
                            ),
                            content: Text(context.l10n.logoutConfirmBody, style: TextStyle(color: context.colors.greyText)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(dialogContext).pop(),
                                child: Text(context.l10n.cancel, style: const TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                                },
                                child: Text(
                                  context.l10n.logout,
                                  style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (menuCtx) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 18, color: menuCtx.colors.primaryText),
                            SizedBox(width: 10),
                            Text(menuCtx.l10n.profile, style: TextStyle(fontSize: 13, color: menuCtx.colors.primaryText)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'theme',
                        child: Row(
                          children: [
                            Icon(
                              menuCtx.read<ThemeCubit>().state == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              size: 18,
                              color: menuCtx.colors.primaryText,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              menuCtx.read<ThemeCubit>().state == ThemeMode.dark ? menuCtx.l10n.lightMode : menuCtx.l10n.darkMode,
                              style: TextStyle(fontSize: 13, color: menuCtx.colors.primaryText),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'language',
                        child: Row(
                          children: [
                            Icon(Icons.language, size: 18, color: menuCtx.colors.primaryText),
                            SizedBox(width: 10),
                            Text(menuCtx.l10n.language, style: TextStyle(fontSize: 13, color: menuCtx.colors.primaryText)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 18, color: Color(0xFFEF4444)),
                            SizedBox(width: 10),
                            Text(menuCtx.l10n.logout, style: TextStyle(fontSize: 13, color: Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Online / Availability toggle banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const _OnlineToggle(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.onlineAcceptingBookings,
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final currentCode = localeCubit.state.languageCode;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.l10n.selectLanguage,
          style: TextStyle(fontWeight: FontWeight.w800, color: context.colors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              label: 'English',
              selected: currentCode == 'en',
              onTap: () {
                localeCubit.setEnglish();
                Navigator.of(dialogContext).pop();
              },
            ),
            const SizedBox(height: 8),
            _LanguageOption(
              label: 'বাংলা',
              selected: currentCode == 'bn',
              onTap: () {
                localeCubit.setBangla();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? const Color(0xFF1A73E8).withOpacity(0.1) : null,
          border: Border.all(color: selected ? const Color(0xFF1A73E8) : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? const Color(0xFF1A73E8) : context.colors.primaryText,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check, size: 18, color: Color(0xFF1A73E8)),
          ],
        ),
      ),
    );
  }
}

// ── Online toggle ─────────────────────────────────────────────────────────────

class _OnlineToggle extends StatefulWidget {
  const _OnlineToggle();

  @override
  State<_OnlineToggle> createState() => _OnlineToggleState();
}

class _OnlineToggleState extends State<_OnlineToggle> {
  bool _online = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _online = !_online),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 48,
        height: 26,
        decoration: BoxDecoration(color: _online ? const Color(0xFF22C55E) : Colors.white38, borderRadius: BorderRadius.circular(13)),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: _online ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final dynamic user;
  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final stats = [
      (label: l10n.totalJobs, value: '${user.completedJobs ?? 0}', icon: Icons.handyman_outlined, color: const Color(0xFF1A73E8), bg: c.lightBlueBg),
      (label: l10n.totalReview, value: '${user.totalReviews ?? 0}', icon: Icons.rate_review_outlined, color: const Color(0xFF22C55E), bg: c.lightGreenBg),
      (label: l10n.rating, value: '${user.totalRatings ?? 0}', icon: Icons.star_rounded, color: const Color(0xFFFACC15), bg: c.lightYellowBg),
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
              boxShadow: [BoxShadow(color: c.shadow, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(s.icon, size: 18, color: s.color),
                ),
                const SizedBox(height: 6),
                Text(
                  s.value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: c.primaryText),
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

// ── Earnings summary ──────────────────────────────────────────────────────────

class _EarningsSummarySection extends StatelessWidget {
  const _EarningsSummarySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A73E8), Color(0xFF00A2D2)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1A73E8).withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.earningsOverview,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const Text('April 2026', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '৳0.00',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
          ),
          const SizedBox(height: 4),
          Text(context.l10n.totalEarningsThisMonth, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              _EarningChip(label: context.l10n.jobsDone, value: '0'),
              const SizedBox(width: 12),
              _EarningChip(label: context.l10n.avgPerJob, value: '৳0'),
              const SizedBox(width: 12),
              _EarningChip(label: context.l10n.pending, value: '৳0'),
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
        decoration: BoxDecoration(color: Colors.white.withAlpha(38), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ── Tips section ──────────────────────────────────────────────────────────────

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final steps = [(l10n.stayOnline, '📡'), (l10n.respondFast, '⚡'), (l10n.earnMore, '💸')];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: c.shadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tipsToEarnMore,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c.primaryText),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Expanded(child: Divider(color: c.lightBlueBg, thickness: 2, height: 2));
              }
              final s = steps[i ~/ 2];
              return Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: c.lightBlueBg, borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text(s.$2, style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.$1,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c.primaryText),
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
