import 'package:flutter/material.dart';

class RecentBookingsSection extends StatelessWidget {
  const RecentBookingsSection({super.key});

  static const _bookings = [
    (
      customer: 'Sabbir Ahmed',
      service: 'Electrical Wiring',
      time: 'Today, 3:00 PM',
      status: 'Pending',
      statusColor: Color(0xFFF59E0B),
      statusBg: Color(0xFFFEF3C7),
    ),
    (
      customer: 'Nadia Islam',
      service: 'Fan Installation',
      time: 'Tomorrow, 10:00 AM',
      status: 'Confirmed',
      statusColor: Color(0xFF22C55E),
      statusBg: Color(0xFFDCFCE7),
    ),
    (
      customer: 'Rashed Khan',
      service: 'Wiring Check',
      time: 'Apr 25, 2:00 PM',
      status: 'Completed',
      statusColor: Color(0xFF1A73E8),
      statusBg: Color(0xFFE8F0FE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            TextButton(
              onPressed: () {},
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
                  Icon(Icons.chevron_right, size: 14, color: Color(0xFF1A73E8)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: _bookings.map((b) {
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
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.customer,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          b.service,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 11,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              b.time,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: b.statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      b.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: b.statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
