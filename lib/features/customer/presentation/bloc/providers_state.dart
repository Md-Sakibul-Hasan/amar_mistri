part of 'providers_bloc.dart';

abstract class ProvidersState extends Equatable {
  const ProvidersState();

  @override
  List<Object> get props => [];
}

class ProvidersInitial extends ProvidersState {
  const ProvidersInitial();
}

class ProvidersLoading extends ProvidersState {
  const ProvidersLoading();
}

class ProvidersLoaded extends ProvidersState {
  final List<AppUser> providers;
  const ProvidersLoaded(this.providers);

  @override
  List<Object> get props => [providers];
}

class ProvidersError extends ProvidersState {
  final String message;
  const ProvidersError(this.message);

  @override
  List<Object> get props => [message];
}
