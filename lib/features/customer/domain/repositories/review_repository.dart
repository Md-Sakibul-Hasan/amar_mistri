import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../provider/data/models/provider_review_model.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> submitReview(String providerUid, String customerUid, int rating, String comment, String bookingId);
  Future<Either<Failure, List<ProviderReviewModel>>> getReviewsByProvider(String providerUid);
}
