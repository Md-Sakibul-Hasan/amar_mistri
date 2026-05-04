part of 'booking_bloc.dart';

enum BookingStatus { initial, submitting, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final String priority;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.priority = 'normal',
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    String? priority,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, priority, errorMessage];
}
