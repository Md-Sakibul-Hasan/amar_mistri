import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final categories = l10n.categories;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.ourServices,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.primaryText),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    l10n.seeAll,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A73E8)),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 14, color: Color(0xFF1A73E8)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final (englishName, label, emoji) = categories[i];
            return GestureDetector(
              onTap: () => context.push('${AppRouter.providersByService}?service=${Uri.encodeComponent(englishName)}'),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: c.lightBlueBg, borderRadius: BorderRadius.circular(14)),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: c.primaryText),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
