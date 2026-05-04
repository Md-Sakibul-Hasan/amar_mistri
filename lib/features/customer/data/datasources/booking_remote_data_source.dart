import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/booking_request.dart';

abstract class BookingRemoteDataSource {
  Future<void> createBooking(BookingRequest request);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  static const String _bookingsCollection = 'Bookings';

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const BookingRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<void> createBooking(BookingRequest request) async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const AuthException('Please log in to continue.');
      }

      final userDoc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        throw const AuthException('Customer profile not found.');
      }

      final userData = userDoc.data()!;
      final now = DateTime.now();
      final service =
          request.provider.services != null &&
              request.provider.services!.isNotEmpty
          ? request.provider.services!.first
          : 'AC Repair';

      final bookingData = {
        'customerUid': firebaseUser.uid,
        'providerUid': request.provider.uid,
        'providerName': request.provider.name,
        'customerName': _resolveName(userData),
        'phone': _resolvePhone(userData),
        'service': service,
        'date': _formatDate(now),
        'status': 'pending',
        'area': request.area,
        'note': request.note,
        'priority': request.priority,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection(_bookingsCollection).add(bookingData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create booking.');
    }
  }

  String _resolveName(Map<String, dynamic> userData) {
    final name = (userData['name'] as String?)?.trim();
    if (name == null || name.isEmpty) return 'Customer';
    return name;
  }

  String _resolvePhone(Map<String, dynamic> userData) {
    final phone = (userData['phone'] as String?)?.trim();
    if (phone == null || phone.isEmpty) return 'N/A';
    return phone;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
