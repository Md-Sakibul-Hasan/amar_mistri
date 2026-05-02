import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/greeting_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/categories_section.dart';
import '../widgets/home_header.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/top_providers_section.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();
    final firstName = authState.user.name.split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(greeting: getGreeting(), firstName: firstName),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const BannerCarousel(),
                  const SizedBox(height: 20),
                  const CategoriesSection(),
                  const SizedBox(height: 20),
                  const TopProvidersSection(),
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
