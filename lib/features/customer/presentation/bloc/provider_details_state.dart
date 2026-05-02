part of 'provider_details_bloc.dart';

abstract class ProviderDetailsState extends Equatable {
  const ProviderDetailsState();

  @override
  List<Object> get props => [];
}

class ProviderDetailsInitial extends ProviderDetailsState {
  const ProviderDetailsInitial();
}

class ProviderDetailsLoading extends ProviderDetailsState {
  const ProviderDetailsLoading();
}

class ProviderDetailsLoaded extends ProviderDetailsState {
  final AppUser provider;
  const ProviderDetailsLoaded(this.provider);

  @override
  List<Object> get props => [provider];
}

class ProviderDetailsError extends ProviderDetailsState {
  final String message;
  const ProviderDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
