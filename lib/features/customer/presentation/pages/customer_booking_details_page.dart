import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/customer_booking.dart';

class CustomerBookingDetailsPage extends StatelessWidget {
  final CustomerBooking booking;

  const CustomerBookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      appBar: AppBar(
        title: Text(l10n.bookingDetails),
        backgroundColor: c.scaffoldBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _card(
              c: c,
              children: [
                Text(
                  l10n.summary,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                _row(l10n.bookingId, booking.bookingId, c),
                _row(l10n.status, booking.status, c),
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.primaryText,
                  ),
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.primaryText,
                  ),
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  booking.note,
                  style: TextStyle(
                    fontSize: 13,
                    color: c.tertiaryText,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ],
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
        boxShadow: [
          BoxShadow(
            color: c.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _row(String label, String value, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: c.secondaryText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.primaryText,
              ),
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
