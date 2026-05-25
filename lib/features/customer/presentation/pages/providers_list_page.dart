import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/domain/entities/app_user.dart';
import '../bloc/providers_bloc.dart';

class ProvidersListPage extends StatelessWidget {
  final String service;
  const ProvidersListPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProvidersBloc>()..add(ProvidersLoadRequested(service: service)),
      child: Scaffold(
        backgroundColor: context.colors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "${service}s",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: BlocBuilder<ProvidersBloc, ProvidersState>(
          builder: (context, state) {
            if (state is ProvidersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProvidersError) {
              return _ErrorView(message: state.message, service: service);
            }
            if (state is ProvidersLoaded) {
              if (state.providers.isEmpty) {
                return _EmptyView(service: service);
              }
              return _ProvidersList(providers: state.providers);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProvidersList extends StatelessWidget {
  final List<AppUser> providers;
  const _ProvidersList({required this.providers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: providers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ProviderCard(provider: providers[i]),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final AppUser provider;
  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initials = provider.name
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return GestureDetector(
      onTap: () => context.push(
        '${AppRouter.providerDetails}?uid=${Uri.encodeComponent(provider.uid)}',
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: c.shadowMedium,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF1A73E8).withValues(alpha: 0.12),
              backgroundImage: provider.photoUrl != null
                  ? NetworkImage(provider.photoUrl!)
                  : null,
              child: provider.photoUrl == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A73E8),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.primaryText,
                    ),
                  ),
                  if (provider.serviceArea != null &&
                      provider.serviceArea!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: c.secondaryText,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          provider.serviceArea!,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (provider.experienceYears != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${provider.experienceYears} yrs experience',
                      style: TextStyle(fontSize: 12, color: c.secondaryText),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.seeDetails,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String service;
  const _EmptyView({required this.service});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😔', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            context.l10n.noProvidersFound(service),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.checkBackSoon,
            style: TextStyle(fontSize: 14, color: c.secondaryText),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final String service;
  const _ErrorView({required this.message, required this.service});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              context.l10n.somethingWentWrong,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: c.secondaryText),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<ProvidersBloc>().add(
                ProvidersLoadRequested(service: service),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
