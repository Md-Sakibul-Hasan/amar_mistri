import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/provider_bookings_bloc.dart';
import '../pages/provider_all_bookings_page.dart';
import 'provider_booking_card.dart';

class RecentBookingsSection extends StatelessWidget {
  const RecentBookingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderBookingsBloc, ProviderBookingsState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Bookings',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (state is ProviderBookingsLoaded &&
                    state.bookings.length > 3)
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProviderBookingsBloc>(),
                          child: const ProviderAllBookingsPage(),
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: Color(0xFF1A73E8),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBody(state),
          ],
        );
      },
    );
  }

  Widget _buildBody(ProviderBookingsState state) {
    if (state is ProviderBookingsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is ProviderBookingsError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            state.message,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state is ProviderBookingsLoaded) {
      if (state.bookings.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No bookings yet.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        );
      }
      final preview = state.bookings.take(3).toList();
      return Column(
        children: preview.map((b) => ProviderBookingCard(booking: b)).toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
