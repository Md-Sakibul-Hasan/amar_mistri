import 'package:amar_mistri/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/customer_booking.dart';
import '../bloc/customer_bookings_bloc.dart';
import 'customer_booking_details_page.dart';

class CustomerBookingListPage extends StatelessWidget {
  const CustomerBookingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CustomerBookingsBloc>()..add(const CustomerBookingsRequested()),
      child: const _CustomerBookingListView(),
    );
  }
}

class _CustomerBookingListView extends StatelessWidget {
  const _CustomerBookingListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldBg,
      appBar: AppBar(
        title: Text(context.l10n.myBookings),
        backgroundColor: context.colors.scaffoldBg,
        elevation: 0,
      ),
      body: BlocBuilder<CustomerBookingsBloc, CustomerBookingsState>(
        builder: (context, state) {
          if (state is CustomerBookingsLoading ||
              state is CustomerBookingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomerBookingsError) {
            return _ErrorView(message: state.message);
          }

          final bookings = (state as CustomerBookingsLoaded).bookings;
          if (bookings.isEmpty) {
            return const _EmptyView();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _BookingCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final CustomerBooking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CustomerBookingDetailsPage(booking: booking),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.lightBlueBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.event_note_rounded,
                color: Color(0xFF1A73E8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.service,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: c.primaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking.providerName,
                    style: TextStyle(fontSize: 12, color: c.secondaryText),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: c.secondaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.date,
                        style: TextStyle(fontSize: 11, color: c.secondaryText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusBg(booking.status, c),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                booking.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _statusColor(booking.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF1A73E8);
      case 'confirmed':
        return const Color(0xFF16A34A);
      case 'pending':
      default:
        return const Color(0xFFD97706);
    }
  }

  Color _statusBg(String status, AppColors c) {
    switch (status.toLowerCase()) {
      case 'completed':
        return c.lightBlueBg;
      case 'confirmed':
        return c.lightGreenBg;
      case 'pending':
      default:
        return c.lightOrangeBg;
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: c.greyText),
            const SizedBox(height: 12),
            Text(
              context.l10n.noBookingsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.bookingsYetBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              context.l10n.couldNotLoadBookings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.secondaryText),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                context.read<CustomerBookingsBloc>().add(
                  const CustomerBookingsRequested(),
                );
              },
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
