import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomeHeader extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String? photoUrl;

  const HomeHeader({super.key, required this.greeting, required this.firstName, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A73E8), Color(0xFF00A2D2)]),
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
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
                  // Location + greeting
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
                                      context.l10n.locationText,
                                      style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white70),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$greeting, $firstName! 👋',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bell icon
                  // Stack(
                  //   children: [
                  //     Container(
                  //       width: 36,
                  //       height: 36,
                  //       decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(18)),
                  //       child: const Icon(Icons.notifications_outlined, size: 18, color: Colors.white),
                  //     ),
                  //     Positioned(
                  //       top: 0,
                  //       right: 0,
                  //       child: Container(
                  //         width: 16,
                  //         height: 16,
                  //         decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                  //         child: const Center(
                  //           child: Text(
                  //             '3',
                  //             style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
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
                              context.l10n.logoutConfirmTitle,
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
                            Text(context.l10n.logout, style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              // Search bar
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              //   child: Row(
              //     children: [
              //       Icon(Icons.search, size: 18, color: Colors.grey.shade400),
              //       const SizedBox(width: 12),
              //       Text(context.l10n.searchHint, style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
              //     ],
              //   ),
              // ),
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
