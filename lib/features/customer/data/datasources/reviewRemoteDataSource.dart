import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/review_model.dart';
import '../../../provider/data/models/provider_review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<void> submitReview(ReviewModel request);
  Future<void> reviewAndRatingsCountUpdate({required String providerId, required double newRating});
  Future<List<ProviderReviewModel>> getReviewsByProvider(String providerUid);
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

      final userData = userDoc.data()!;

      final reviewRef = firestore.collection(_reviewsCollection).doc();

      final reviewData = {
        'reviewId': reviewRef.id,
        'providerUid': request.providerId,
        'customerUid': request.customerId,
        'rating': request.rating,
        'comment': request.comment,
        'bookingId': request.bookingId,
        'timestamp': FieldValue.serverTimestamp(),
        'reviewerData': userData,
      };

      await reviewRef.set(reviewData);
      await reviewAndRatingsCountUpdate(providerId: request.providerId, newRating: request.rating.toDouble());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to submit review.');
    }
  }

  @override
  Future<void> reviewAndRatingsCountUpdate({required String providerId, required double newRating}) async {
    final providerRef = FirebaseFirestore.instance.collection('users').doc(providerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(providerRef);

      final data = snapshot.data()!;

      final currentRating = (data['ratings'] ?? 0).toDouble();

      final totalReviews = (data['totalReviews'] ?? 0);
      final currentTotalRatings = (data['totalRatings'] ?? 0);

      final totalRatingScore = currentRating * totalReviews;
      final totalRatings = currentTotalRatings + newRating;

      final updatedReviews = totalReviews + 1;

      final updatedRating = (totalRatingScore + newRating) / updatedReviews;

      transaction.update(providerRef, {'ratings': updatedRating, 'totalReviews': updatedReviews, 'totalRatings': totalRatings});
    });
  }

  @override
  Future<List<ProviderReviewModel>> getReviewsByProvider(String providerUid) async {
    try {
      final querySnapshot = await firestore
          .collection(_reviewsCollection)
          .where('providerUid', isEqualTo: providerUid)
          .get();
      final reviews = querySnapshot.docs
          .map((doc) => ProviderReviewModel.fromMap(doc.id, doc.data()))
          .toList();
      reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return reviews;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to load reviews.');
    }
  }
}
