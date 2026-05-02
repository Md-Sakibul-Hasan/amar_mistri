part of 'provider_details_bloc.dart';

abstract class ProviderDetailsEvent extends Equatable {
  const ProviderDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProviderDetailsLoadRequested extends ProviderDetailsEvent {
  final String uid;
  const ProviderDetailsLoadRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}
