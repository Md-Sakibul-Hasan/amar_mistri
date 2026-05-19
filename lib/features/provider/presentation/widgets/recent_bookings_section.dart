import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/entities/customer_booking.dart';
import '../bloc/provider_bookings_bloc.dart';

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
                    onPressed: () => _showAllBookings(context, state.bookings),
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
        children: preview.map((b) => _BookingCard(booking: b)).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  void _showAllBookings(BuildContext context, List<CustomerBooking> bookings) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AllBookingsSheet(bookings: bookings),
    );
  }
}

// ── Full list bottom sheet ────────────────────────────────────────────────────

class _AllBookingsSheet extends StatelessWidget {
  final List<CustomerBooking> bookings;

  const _AllBookingsSheet({required this.bookings});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'All Bookings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: bookings.length,
                itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single booking card ───────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final CustomerBooking booking;

  const _BookingCard({required this.booking});

  static ({Color fg, Color bg}) _statusColors(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return (fg: const Color(0xFF22C55E), bg: const Color(0xFFDCFCE7));
      case 'completed':
        return (fg: const Color(0xFF1A73E8), bg: const Color(0xFFE8F0FE));
      case 'cancelled':
      case 'rejected':
        return (fg: const Color(0xFFEF4444), bg: const Color(0xFFFEE2E2));
      default: // pending
        return (fg: const Color(0xFFF59E0B), bg: const Color(0xFFFEF3C7));
    }
  }

  static Widget _avatarFallback() => Container(
    width: 42,
    height: 42,
    decoration: const BoxDecoration(color: Color(0xFFE8F0FE)),
    child: const Center(
      child: Icon(Icons.person, size: 22, color: Color(0xFF1A73E8)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(booking.status);
    final statusLabel =
        booking.status[0].toUpperCase() + booking.status.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                booking.customerPhotoUrl != null &&
                    booking.customerPhotoUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: booking.customerPhotoUrl!,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _avatarFallback(),
                    errorWidget: (_, __, ___) => _avatarFallback(),
                  )
                : _avatarFallback(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Service: ${booking.service}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      booking.date,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    if (booking.area.isNotEmpty && booking.area != '-') ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 11,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          booking.area,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
