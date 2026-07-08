part of 'provider_reviews_bloc.dart';

abstract class ProviderReviewsState extends Equatable {
  const ProviderReviewsState();

  @override
  List<Object?> get props => [];
}

class ProviderReviewsInitial extends ProviderReviewsState {
  const ProviderReviewsInitial();
}

class ProviderReviewsLoading extends ProviderReviewsState {
  const ProviderReviewsLoading();
}

class ProviderReviewsLoaded extends ProviderReviewsState {
  final List<ProviderReviewModel> reviews;

  const ProviderReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ProviderReviewsError extends ProviderReviewsState {
  final String message;

  const ProviderReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
