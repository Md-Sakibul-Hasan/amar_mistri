import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/review_model.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/reviewRemoteDataSource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  const ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitReview(String providerUid, String customerUid, int rating, String comment, String bookingId) async {
    final review = ReviewModel(
      reviewId: '', // Firestore will generate this
      providerId: providerUid,
      customerId: customerUid,
      rating: rating.toInt(),
      comment: comment,
      bookingId: bookingId,
    );

    try {
      await remoteDataSource.submitReview(review);
      return const Right(null);
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}
