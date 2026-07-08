import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderReviewModel {
  final String reviewId;
  final String bookingId;
  final String comment;
  final String customerUid;
  final String providerUid;
  final int rating;
  final DateTime timestamp;

  final String? customerName;
  final String? customerPhotoUrl;

  const ProviderReviewModel({
    required this.reviewId,
    required this.bookingId,
    required this.comment,
    required this.customerUid,
    required this.providerUid,
    required this.rating,
    required this.timestamp,
    this.customerName,
    this.customerPhotoUrl,
  });

  factory ProviderReviewModel.fromMap(String id, Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    final reviewerData = map['reviewerData'] as Map<String, dynamic>?;

    return ProviderReviewModel(
      reviewId: map['reviewId'] as String? ?? id,
      bookingId: map['bookingId'] as String? ?? '',
      comment: map['comment'] as String? ?? '',
      customerUid: map['customerUid'] as String? ?? '',
      providerUid: map['providerUid'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      timestamp: parsedTimestamp,
      customerName: reviewerData?['name'] as String?,
      customerPhotoUrl: reviewerData?['photoUrl'] as String?,
    );
  }
}
