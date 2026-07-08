import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../provider/data/models/provider_review_model.dart';
import '../repositories/review_repository.dart';

class GetProviderReviewsUseCase
    implements UseCase<List<ProviderReviewModel>, ProviderReviewsParams> {
  final ReviewRepository repository;

  const GetProviderReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProviderReviewModel>>> call(
    ProviderReviewsParams params,
  ) {
    return repository.getReviewsByProvider(params.providerUid);
  }
}

class ProviderReviewsParams extends Equatable {
  final String providerUid;

  const ProviderReviewsParams(this.providerUid);

  @override
  List<Object?> get props => [providerUid];
}
