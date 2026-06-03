import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<void> submitReview(ReviewModel request);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  static const String _reviewsCollection = 'Reviews';

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const ReviewRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  @override
  Future<void> submitReview(ReviewModel request) async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw const AuthException('Please log in to continue.');
      }

      final userDoc = await firestore.collection(AppConstants.usersCollection).doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        throw const AuthException('Customer profile not found.');
      }

      final reviewRef = firestore.collection(_reviewsCollection).doc();

      final reviewData = {
        'reviewId': reviewRef.id,
        'providerUid': request.providerId,
        'customerUid': request.customerId,
        'rating': request.rating,
        'comment': request.comment,
        'bookingId': request.bookingId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await reviewRef.set(reviewData);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to submit review.');
    }
  }
}
