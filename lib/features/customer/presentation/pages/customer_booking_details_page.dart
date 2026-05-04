import 'package:flutter/material.dart';

import '../../domain/entities/customer_booking.dart';

class CustomerBookingDetailsPage extends StatelessWidget {
  final CustomerBooking booking;

  const CustomerBookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _card(
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 12),
                _row('Booking ID', booking.bookingId),
                _row('Status', booking.status),
                _row('Date', booking.date),
                _row('Created', _formatCreatedAt(booking.createdAt)),
              ],
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                const Text(
                  'Service Info',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 12),
                _row('Service', booking.service),
                _row('Provider', booking.providerName),
                _row('Area', booking.area),
                _row('Priority', booking.priority),
              ],
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                const Text(
                  'Customer Info',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 12),
                _row('Name', booking.customerName),
                _row('Phone', booking.phone),
              ],
            ),
            const SizedBox(height: 12),
            _card(
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  booking.note,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
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

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _row(String label, String value) {
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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
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
