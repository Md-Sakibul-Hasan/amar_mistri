import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final AnimationController _iconsController;
  late final Animation<double> _iconsOpacity;
  late final Animation<Offset> _iconsSlide;

  late final AnimationController _dotsController;

  static const _serviceEmojis = ['⚡', '🔧', '❄️', '🎨', '🪚'];

  @override
  void initState() {
    super.initState();

    // Logo bounce-in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    // Service icons fade+slide
    _iconsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iconsOpacity = CurvedAnimation(
      parent: _iconsController,
      curve: Curves.easeIn,
    );
    _iconsSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _iconsController, curve: Curves.easeOut));

    // Dots bounce loop
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Start sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _iconsController.forward();
    });

    // Navigate after 2.5 s
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final destination = authState.user.role == UserRole.provider
            ? AppRouter.providerHome
            : AppRouter.customerHome;
        context.go(destination);
      } else {
        context.go(AppRouter.roleSelection);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _iconsController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.brandGradient),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Decorative circles
            Positioned(top: -80, right: -80, child: AppTheme.circle(300, 0.10)),
            Positioned(
              bottom: 60,
              left: -60,
              child: AppTheme.circle(200, 0.10),
            ),
            Positioned(
              bottom: 200,
              right: 20,
              child: AppTheme.circle(150, 0.05),
            ),

            // Center logo + brand
            Center(
              child: FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo icon
                      _LogoBadge(),
                      const SizedBox(height: 24),
                      // Brand name
                      AppTheme.brandName(fontSize: 36),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.splashTagline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Service icons row
            Positioned(
              bottom: 104,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _iconsOpacity,
                child: SlideTransition(
                  position: _iconsSlide,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _serviceEmojis.map((e) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withAlpha(77)),
                        ),
                        child: Center(
                          child: Text(e, style: const TextStyle(fontSize: 20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Loading dots + label
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return AnimatedBuilder(
                        animation: _dotsController,
                        builder: (_, __) {
                          final offset = ((_dotsController.value * 3) - i)
                              .clamp(0.0, 1.0);
                          final t = math.sin(offset * math.pi).clamp(0.0, 1.0);
                          final scale = 0.6 + 0.4 * t;
                          final opacity = 0.4 + 0.6 * t;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 6 * scale,
                            height: 6 * scale,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(
                                (255 * opacity).round(),
                              ),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outer glass container
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(102), width: 2),
            ),
            child: Center(
              // Inner white container
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('🏠', style: TextStyle(fontSize: 36)),
                ),
              ),
            ),
          ),
          // Teal zap badge
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppTheme.teal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
