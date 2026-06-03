import 'package:equatable/equatable.dart';

class CustomerBooking extends Equatable {
  final String bookingId;
  final String providerUid;
  final String customerUid;
  final String providerName;
  final String customerName;
  final String phone;
  final String service;
  final String date;
  final String status;
  final String area;
  final String note;
  final String priority;
  final DateTime? createdAt;
  final String? customerPhotoUrl;

  const CustomerBooking({
    required this.bookingId,
    required this.providerUid,
    required this.providerName,
    required this.customerName,
    required this.phone,
    required this.service,
    required this.date,
    required this.status,
    required this.area,
    required this.note,
    required this.priority,
    required this.createdAt,
    required this.customerUid,
    this.customerPhotoUrl,
  });

  @override
  List<Object?> get props => [
    bookingId,
    providerUid,
    providerName,
    customerName,
    phone,
    service,
    date,
    status,
    area,
    note,
    priority,
    createdAt,
    customerPhotoUrl,
    customerUid,
  ];
}
