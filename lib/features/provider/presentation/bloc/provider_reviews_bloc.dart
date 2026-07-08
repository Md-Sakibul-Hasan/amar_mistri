import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/usecases/get_provider_reviews_usecase.dart';
import '../../data/models/provider_review_model.dart';

part 'provider_reviews_event.dart';
part 'provider_reviews_state.dart';

class ProviderReviewsBloc extends Bloc<ProviderReviewsEvent, ProviderReviewsState> {
  final GetProviderReviewsUseCase getProviderReviewsUseCase;

  ProviderReviewsBloc({required this.getProviderReviewsUseCase})
      : super(const ProviderReviewsInitial()) {
    on<ProviderReviewsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    ProviderReviewsRequested event,
    Emitter<ProviderReviewsState> emit,
  ) async {
    emit(const ProviderReviewsLoading());

    final result = await getProviderReviewsUseCase(
      ProviderReviewsParams(event.providerUid),
    );

    result.fold(
      (failure) => emit(ProviderReviewsError(failure.message)),
      (reviews) => emit(ProviderReviewsLoaded(reviews)),
    );
  }
}
