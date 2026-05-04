part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class BookingPriorityChanged extends BookingEvent {
  final String priority;

  const BookingPriorityChanged({required this.priority});

  @override
  List<Object?> get props => [priority];
}

class BookingSubmitted extends BookingEvent {
  final AppUser provider;
  final String area;
  final String note;

  const BookingSubmitted({
    required this.provider,
    required this.area,
    required this.note,
  });

  @override
  List<Object?> get props => [provider, area, note];
}
