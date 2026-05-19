import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/entities/customer_booking.dart';
import '../bloc/provider_bookings_bloc.dart';
import 'provider_booking_detail_sheet.dart';

class ProviderBookingCard extends StatelessWidget {
  final CustomerBooking booking;

  const ProviderBookingCard({super.key, required this.booking});

  static ({Color fg, Color bg}) _statusColors(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
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

    return InkWell(
      onTap: () {
        final bloc = context.read<ProviderBookingsBloc>();
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: ProviderBookingDetailSheet(booking: booking),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
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
      ),
    );
  }
}
