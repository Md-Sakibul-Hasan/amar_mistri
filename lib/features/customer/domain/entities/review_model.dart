import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String reviewId;
  final String bookingId;
  final String providerId;
  final String customerId;
  final int rating;
  final String comment;

  const ReviewModel({
    required this.reviewId,
    required this.bookingId,
    required this.providerId,
    required this.customerId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
    'reviewId': reviewId,
    'bookingId': bookingId,
    'providerId': providerId,
    'customerId': customerId,
    'rating': rating,
    'comment': comment,
    'createdAt': FieldValue.serverTimestamp(),
  };

  @override
  List<Object?> get props => [reviewId, bookingId, providerId, customerId, rating, comment];
}
