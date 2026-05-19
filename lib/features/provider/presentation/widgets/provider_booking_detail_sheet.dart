import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/entities/customer_booking.dart';
import '../bloc/provider_bookings_bloc.dart';

class ProviderBookingDetailSheet extends StatelessWidget {
  final CustomerBooking booking;

  const ProviderBookingDetailSheet({super.key, required this.booking});

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

  String _formatCreatedAt(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProviderBookingsBloc, ProviderBookingsState>(
      listenWhen: (_, state) =>
          state is ProviderBookingStatusUpdated ||
          state is ProviderBookingStatusUpdateFailed,
      listener: (context, state) {
        if (state is ProviderBookingStatusUpdated) {
          final label = state.newStatus == 'accepted'
              ? 'Booking accepted'
              : 'Booking rejected';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(label),
              backgroundColor: state.newStatus == 'accepted'
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFEF4444),
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ProviderBookingStatusUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      buildWhen: (_, state) =>
          state is ProviderBookingStatusUpdating ||
          state is ProviderBookingStatusUpdated ||
          state is ProviderBookingStatusUpdateFailed,
      builder: (context, state) {
        // Resolve the displayed status: use updated status when available,
        // otherwise keep the original booking status.
        final displayStatus = state is ProviderBookingStatusUpdated
            ? state.newStatus
            : booking.status;
        final colors = _statusColors(displayStatus);
        final statusLabel =
            displayStatus[0].toUpperCase() + displayStatus.substring(1);
        final isPending = displayStatus.toLowerCase() == 'pending';
        final isUpdating = state is ProviderBookingStatusUpdating;

        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // ── drag handle ────────────────────────────────────────
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

                // ── header ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child:
                            booking.customerPhotoUrl != null &&
                                booking.customerPhotoUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: booking.customerPhotoUrl!,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _avatarFallback(),
                                errorWidget: (_, __, ___) => _avatarFallback(),
                              )
                            : _avatarFallback(),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: booking.phone),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Phone number copied'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 13,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.copy,
                                    size: 11,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.bg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colors.fg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // ── scrollable detail cards ────────────────────────────
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    children: [
                      _card(
                        icon: Icons.build_outlined,
                        title: 'Service Info',
                        rows: [
                          _InfoRow(label: 'Service', value: booking.service),
                          _InfoRow(label: 'Date', value: booking.date),
                          _InfoRow(
                            label: 'Priority',
                            value:
                                booking.priority[0].toUpperCase() +
                                booking.priority.substring(1),
                          ),
                          if (booking.area.isNotEmpty && booking.area != '-')
                            _InfoRow(label: 'Area', value: booking.area),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _card(
                        icon: Icons.receipt_long_outlined,
                        title: 'Booking Summary',
                        rows: [
                          _InfoRow(
                            label: 'Booking ID',
                            value: booking.bookingId,
                            mono: true,
                          ),
                          _InfoRow(
                            label: 'Submitted',
                            value: _formatCreatedAt(booking.createdAt),
                          ),
                        ],
                      ),
                      if (booking.note.isNotEmpty && booking.note != '-') ...[
                        const SizedBox(height: 12),
                        _noteCard(booking.note),
                      ],
                    ],
                  ),
                ),

                // ── Accept / Reject buttons (pending only) ─────────────
                if (isPending)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: isUpdating
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      context.read<ProviderBookingsBloc>().add(
                                        ProviderBookingStatusUpdateRequested(
                                          bookingId: booking.bookingId,
                                          status: 'rejected',
                                          providerUid: booking.providerUid,
                                        ),
                                      ),
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Reject'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFEF4444),
                                    side: const BorderSide(
                                      color: Color(0xFFEF4444),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      context.read<ProviderBookingsBloc>().add(
                                        ProviderBookingStatusUpdateRequested(
                                          bookingId: booking.bookingId,
                                          status: 'accepted',
                                          providerUid: booking.providerUid,
                                        ),
                                      ),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF22C55E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _avatarFallback() => Container(
    width: 52,
    height: 52,
    color: const Color(0xFFE8F0FE),
    child: const Center(
      child: Icon(Icons.person, size: 26, color: Color(0xFF1A73E8)),
    ),
  );

  Widget _card({
    required IconData icon,
    required String title,
    required List<_InfoRow> rows,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1A73E8)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _noteCard(String note) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notes_outlined, size: 16, color: Color(0xFF1A73E8)),
              SizedBox(width: 6),
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  const _InfoRow({required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
