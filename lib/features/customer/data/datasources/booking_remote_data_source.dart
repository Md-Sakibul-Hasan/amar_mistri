import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/entities/customer_booking.dart';

abstract class BookingRemoteDataSource {
  Future<void> createBooking(BookingRequest request);
  Future<List<CustomerBooking>> getCustomerBookings();
  Future<List<CustomerBooking>> getProviderBookings(String providerUid);
  Future<void> updateBookingStatus(String bookingId, String status);
  Future<void> updateProviderCompletedJobs(String providerUid);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  static const String _bookingsCollection = 'Bookings';

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const BookingRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  @override
  updateProviderCompletedJobs(String providerUid) async {
    try {
      final providerDoc = firestore.collection(AppConstants.usersCollection).doc(providerUid);
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(providerDoc);
        if (!snapshot.exists) {
          throw const ServerException('Provider not found.');
        }
        final data = snapshot.data()!;
        final currentJobs = (data['completedJobs'] as int?) ?? 0;
        transaction.update(providerDoc, {'completedJobs': currentJobs + 1});
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update completed jobs.');
    }
  }

  @override
  Future<void> createBooking(BookingRequest request) async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const AuthException('Please log in to continue.');
      }

      final userDoc = await firestore.collection(AppConstants.usersCollection).doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        throw const AuthException('Customer profile not found.');
      }

      final userData = userDoc.data()!;
      final now = DateTime.now();
      final service = request.provider.services != null && request.provider.services!.isNotEmpty ? request.provider.services!.first : 'AC Repair';

      final bookingRef = firestore.collection(_bookingsCollection).doc();

      final bookingData = {
        'bookingId': bookingRef.id,
        'customerUid': firebaseUser.uid,
        'providerUid': request.provider.uid,
        'providerName': request.provider.name,
        'customerName': _resolveName(userData),
        'customerPhotoUrl': (userData['photoUrl'] as String?)?.trim(),
        'phone': _resolvePhone(userData),
        'service': service,
        'date': _formatDate(now),
        'status': 'pending',
        'area': request.area,
        'note': request.note,
        'priority': request.priority,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await bookingRef.set(bookingData);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create booking.');
    }
  }

  @override
  Future<List<CustomerBooking>> getCustomerBookings() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const AuthException('Please log in to continue.');
      }

      final querySnapshot = await firestore.collection(_bookingsCollection).where('customerUid', isEqualTo: firebaseUser.uid).get();

      final bookings = querySnapshot.docs.map(_mapBookingDoc).toList();
      bookings.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
      return bookings;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to load bookings.');
    }
  }

  @override
  Future<List<CustomerBooking>> getProviderBookings(String providerUid) async {
    try {
      final querySnapshot = await firestore.collection(_bookingsCollection).where('providerUid', isEqualTo: providerUid).get();

      final bookings = querySnapshot.docs.map(_mapBookingDoc).toList();
      bookings.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
      return bookings;
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to load bookings.');
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

  @override
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await firestore.collection(_bookingsCollection).doc(bookingId).update({'status': status});
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update booking status.');
    }
  }

  CustomerBooking _mapBookingDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data();
    final timestamp = map['createdAt'] as Timestamp?;
    return CustomerBooking(
      bookingId: (map['bookingId'] as String?)?.trim().isNotEmpty == true ? (map['bookingId'] as String) : doc.id,
      providerUid: (map['providerUid'] as String?) ?? '',
      providerName: (map['providerName'] as String?) ?? 'Provider',
      customerName: (map['customerName'] as String?) ?? 'Customer',
      customerPhotoUrl: map['customerPhotoUrl'] as String?,
      phone: (map['phone'] as String?) ?? 'N/A',
      service: (map['service'] as String?) ?? 'Service',
      date: (map['date'] as String?) ?? '-',
      status: (map['status'] as String?) ?? 'pending',
      area: (map['area'] as String?) ?? '-',
      note: (map['note'] as String?) ?? '-',
      priority: (map['priority'] as String?) ?? 'normal',
      createdAt: timestamp?.toDate(),
      customerUid: (map['customerUid'] as String?) ?? '',
    );
  }
}
