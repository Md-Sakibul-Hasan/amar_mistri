part of 'provider_reviews_bloc.dart';

abstract class ProviderReviewsEvent extends Equatable {
  const ProviderReviewsEvent();

  @override
  List<Object?> get props => [];
}

class ProviderReviewsRequested extends ProviderReviewsEvent {
  final String providerUid;

  const ProviderReviewsRequested(this.providerUid);

  @override
  List<Object?> get props => [providerUid];
}
