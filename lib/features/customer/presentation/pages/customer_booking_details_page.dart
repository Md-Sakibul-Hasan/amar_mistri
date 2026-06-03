import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../provider/presentation/bloc/provider_bookings_bloc.dart';
import '../../domain/entities/customer_booking.dart';
import '../bloc/review_bloc.dart';
import '../widgets/review_bottom_sheet.dart';

class CustomerBookingDetailsPage extends StatelessWidget {
  final CustomerBooking booking;

  const CustomerBookingDetailsPage({super.key, required this.booking});

  static ({Color fg, Color bg}) _statusColors(String status, AppColors c) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return (fg: const Color(0xFF22C55E), bg: c.lightGreenBg);
      case 'completed':
        return (fg: const Color(0xFF1A73E8), bg: c.lightBlueBg);
      case 'cancelled':
      case 'rejected':
        return (fg: const Color(0xFFEF4444), bg: c.lightRedBg);
      default: // pending
        return (fg: const Color(0xFFF59E0B), bg: c.lightOrangeBg);
    }
  }

  void showReviewBottomSheet({
    required BuildContext context,
    required String bookingId,
    required String customerId,
    required String providerId,
    VoidCallback? onSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => ReviewBloc(submitReviewUseCase: sl()),
        child: ReviewBottomSheet(bookingId: bookingId, providerId: providerId, onSuccess: onSuccess, customerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      appBar: AppBar(title: Text(l10n.bookingDetails), backgroundColor: c.scaffoldBg, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: BlocConsumer<ProviderBookingsBloc, ProviderBookingsState>(
          listenWhen: (_, state) => state is ProviderBookingStatusUpdated || state is ProviderBookingStatusUpdateFailed,
          listener: (context, state) {
            if (state is ProviderBookingStatusUpdated) {
              final label = state.newStatus == 'completed' ? context.l10n.bookingCompleted : context.l10n.bookingRejected;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(label), backgroundColor: state.newStatus == 'completed' ? const Color(0xFF22C55E) : const Color(0xFFEF4444)),
              );
              if (label == context.l10n.bookingCompleted) {
                // Optionally, pop the page after completion
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showReviewBottomSheet(
                  context: context,
                  bookingId: booking.bookingId,
                  providerId: booking.providerUid,
                  customerId: booking.customerUid,
                );
              }
            } else if (state is ProviderBookingStatusUpdateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: const Color(0xFFEF4444)));
            }
          },
          buildWhen: (_, state) =>
              state is ProviderBookingStatusUpdating || state is ProviderBookingStatusUpdated || state is ProviderBookingStatusUpdateFailed,
          builder: (context, state) {
            // Resolve the displayed status: use updated status when available,
            // otherwise keep the original booking status.
            final displayStatus = state is ProviderBookingStatusUpdated ? state.newStatus : booking.status;
            final c = context.colors;
            final colors = _statusColors(displayStatus, c);
            final statusLabel = displayStatus[0].toUpperCase() + displayStatus.substring(1);
            final isUpdating = state is ProviderBookingStatusUpdating;

            return Column(
              children: [
                _card(
                  c: c,
                  children: [
                    Text(
                      l10n.summary,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.primaryText),
                    ),
                    const SizedBox(height: 12),
                    _row(l10n.bookingId, booking.bookingId, c),
                    _row(l10n.status, statusLabel, c),
                    _row(l10n.date, booking.date, c),
                    _row(l10n.created, _formatCreatedAt(booking.createdAt), c),
                  ],
                ),
                const SizedBox(height: 12),
                _card(
                  c: c,
                  children: [
                    Text(
                      l10n.serviceInfo,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.primaryText),
                    ),
                    const SizedBox(height: 12),
                    _row(l10n.service, booking.service, c),
                    _row(l10n.provider, booking.providerName, c),
                    _row(l10n.area, booking.area, c),
                    _row(l10n.priority, booking.priority, c),
                  ],
                ),
                const SizedBox(height: 12),
                _card(
                  c: c,
                  children: [
                    Text(
                      l10n.customerInfo,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.primaryText),
                    ),
                    const SizedBox(height: 12),
                    _row(l10n.name, booking.customerName, c),
                    _row(l10n.phone, booking.phone, c),
                  ],
                ),
                const SizedBox(height: 12),
                _card(
                  c: c,
                  children: [
                    Text(
                      l10n.description,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.primaryText),
                    ),
                    const SizedBox(height: 10),
                    Text(booking.note, style: TextStyle(fontSize: 13, color: c.tertiaryText, height: 1.45)),
                  ],
                ),
                if (displayStatus == 'accepted')
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, MediaQuery.of(context).padding.bottom + 16),
                    child: isUpdating
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () => context.read<ProviderBookingsBloc>().add(
                                ProviderBookingStatusUpdateRequested(
                                  bookingId: booking.bookingId,
                                  status: 'completed',
                                  providerUid: booking.providerUid,
                                ),
                              ),
                              icon: const Icon(Icons.check, size: 16),
                              label: Text(context.l10n.complete),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73E8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                            ),
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _card({required AppColors c, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: c.shadowMedium, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _row(String label, String value, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 12, color: c.secondaryText)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c.primaryText),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCreatedAt(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
