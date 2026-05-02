part of 'providers_bloc.dart';

abstract class ProvidersEvent extends Equatable {
  const ProvidersEvent();

  @override
  List<Object> get props => [];
}

class ProvidersLoadRequested extends ProvidersEvent {
  final String service;
  const ProvidersLoadRequested({required this.service});

  @override
  List<Object> get props => [service];
}
