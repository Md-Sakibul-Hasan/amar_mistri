import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> submitReview(String providerUid, String customerUid, int rating, String comment, String bookingId);
}
