import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: const Color(0xFFF5F7FA),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                color: const Color(0xFFE8F0FE),
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking.providerName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusBg(booking.status),
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

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFFE8F0FE);
      case 'confirmed':
        return const Color(0xFFDCFCE7);
      case 'pending':
      default:
        return const Color(0xFFFEF3C7);
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 56, color: Color(0xFF9CA3AF)),
            SizedBox(height: 12),
            Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Your bookings will appear here after you place one.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            const Text(
              'Could not load bookings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {
                context.read<CustomerBookingsBloc>().add(
                  const CustomerBookingsRequested(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
