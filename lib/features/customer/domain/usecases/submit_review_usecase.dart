import 'package:amar_mistri/features/customer/domain/entities/review_model.dart';
import 'package:amar_mistri/features/customer/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SubmitReviewUseCase implements UseCase<void, SubmitReviewParams> {
  final ReviewRepository repository;

  const SubmitReviewUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitReviewParams params) async {
    return repository.submitReview(
      params.request.providerId,
      params.request.customerId,
      params.request.rating,
      params.request.comment,
      params.request.bookingId,
    );
  }
}

class SubmitReviewParams extends Equatable {
  final ReviewModel request;

  const SubmitReviewParams({required this.request});

  @override
  List<Object?> get props => [request];
}
