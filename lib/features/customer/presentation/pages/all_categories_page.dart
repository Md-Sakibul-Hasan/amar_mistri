import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final categories = l10n.categories;

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      appBar: AppBar(
        title: Text(l10n.ourServices, style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: c.cardBg,
        foregroundColor: c.primaryText,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final (englishName, label, emoji) = categories[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(
                '${AppRouter.providersByService}?service=${Uri.encodeComponent(englishName)}',
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: c.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: c.lightBlueBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.primaryText),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: c.greyIcon, size: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
