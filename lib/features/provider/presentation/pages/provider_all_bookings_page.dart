import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';

import '../bloc/provider_bookings_bloc.dart';
import '../widgets/provider_booking_card.dart';

class ProviderAllBookingsPage extends StatelessWidget {
  const ProviderAllBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      appBar: AppBar(
        backgroundColor: c.scaffoldBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'All Bookings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: c.primaryText,
          ),
        ),
      ),
      body: BlocBuilder<ProviderBookingsBloc, ProviderBookingsState>(
        builder: (context, state) {
          if (state is ProviderBookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProviderBookingsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  style: TextStyle(fontSize: 13, color: c.greyText),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is ProviderBookingsLoaded) {
            if (state.bookings.isEmpty) {
              return Center(
                child: Text(
                  'No bookings yet.',
                  style: TextStyle(fontSize: 13, color: c.greyText),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              itemCount: state.bookings.length,
              itemBuilder: (_, i) =>
                  ProviderBookingCard(booking: state.bookings[i]),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
