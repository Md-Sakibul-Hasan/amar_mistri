part of 'customer_bookings_bloc.dart';

abstract class CustomerBookingsState extends Equatable {
  const CustomerBookingsState();

  @override
  List<Object?> get props => [];
}

class CustomerBookingsInitial extends CustomerBookingsState {
  const CustomerBookingsInitial();
}

class CustomerBookingsLoading extends CustomerBookingsState {
  const CustomerBookingsLoading();
}

class CustomerBookingsLoaded extends CustomerBookingsState {
  final List<CustomerBooking> bookings;

  const CustomerBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class CustomerBookingsError extends CustomerBookingsState {
  final String message;

  const CustomerBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
