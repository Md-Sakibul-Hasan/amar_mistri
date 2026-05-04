part of 'customer_bookings_bloc.dart';

abstract class CustomerBookingsEvent extends Equatable {
  const CustomerBookingsEvent();

  @override
  List<Object?> get props => [];
}

class CustomerBookingsRequested extends CustomerBookingsEvent {
  const CustomerBookingsRequested();
}
