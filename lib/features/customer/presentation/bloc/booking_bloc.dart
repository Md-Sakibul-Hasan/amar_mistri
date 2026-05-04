import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/usecases/create_booking_usecase.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;

  BookingBloc({required this.createBookingUseCase})
    : super(const BookingState()) {
    on<BookingPriorityChanged>(_onPriorityChanged);
    on<BookingSubmitted>(_onSubmitted);
  }

  void _onPriorityChanged(
    BookingPriorityChanged event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(priority: event.priority));
  }

  Future<void> _onSubmitted(
    BookingSubmitted event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.submitting, clearError: true));

    final request = BookingRequest(
      provider: event.provider,
      area: event.area,
      note: event.note,
      priority: state.priority,
    );

    final result = await createBookingUseCase(
      CreateBookingParams(request: request),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: BookingStatus.success, clearError: true)),
    );
  }
}
