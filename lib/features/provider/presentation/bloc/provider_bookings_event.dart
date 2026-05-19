part of 'provider_bookings_bloc.dart';

abstract class ProviderBookingsEvent extends Equatable {
  const ProviderBookingsEvent();

  @override
  List<Object?> get props => [];
}

class ProviderBookingsRequested extends ProviderBookingsEvent {
  final String providerUid;

  const ProviderBookingsRequested(this.providerUid);

  @override
  List<Object?> get props => [providerUid];
}
