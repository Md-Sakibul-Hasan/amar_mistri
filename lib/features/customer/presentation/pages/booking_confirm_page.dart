import 'package:flutter/material.dart';

import 'customer_booking_list_page.dart';

class BookingConfirmPage extends StatelessWidget {
  const BookingConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 60,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your booking request has been submitted successfully. '
                      'The provider will review it and get back to you soon.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _InfoTile(
                      icon: Icons.access_time_rounded,
                      title: 'What happens next?',
                      description:
                          'The provider will confirm your request and contact you to schedule a visit.',
                    ),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Stay notified',
                      description:
                          'You will receive a notification once the provider accepts your booking.',
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const CustomerBookingListPage(),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View My Bookings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1A73E8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
