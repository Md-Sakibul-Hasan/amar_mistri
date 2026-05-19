part of 'provider_bookings_bloc.dart';

abstract class ProviderBookingsState extends Equatable {
  const ProviderBookingsState();

  @override
  List<Object?> get props => [];
}

class ProviderBookingsInitial extends ProviderBookingsState {
  const ProviderBookingsInitial();
}

class ProviderBookingsLoading extends ProviderBookingsState {
  const ProviderBookingsLoading();
}

class ProviderBookingsLoaded extends ProviderBookingsState {
  final List<CustomerBooking> bookings;

  const ProviderBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class ProviderBookingsError extends ProviderBookingsState {
  final String message;

  const ProviderBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
