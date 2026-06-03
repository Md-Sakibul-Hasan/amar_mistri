import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/entities/customer_booking.dart';
import '../../../../features/customer/domain/usecases/get_provider_bookings_usecase.dart';
import '../../../../features/customer/domain/usecases/update_booking_status_usecase.dart';
import '../../../customer/domain/usecases/IncrementCompletedJobsUseCase.dart';

part 'provider_bookings_event.dart';
part 'provider_bookings_state.dart';

class ProviderBookingsBloc extends Bloc<ProviderBookingsEvent, ProviderBookingsState> {
  final GetProviderBookingsUseCase getProviderBookingsUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;
  final IncrementCompletedJobsUseCase incrementCompletedJobsUseCase;

  ProviderBookingsBloc({
    required this.getProviderBookingsUseCase,
    required this.updateBookingStatusUseCase,
    required this.incrementCompletedJobsUseCase,
  }) : super(const ProviderBookingsInitial()) {
    on<ProviderBookingsRequested>(_onRequested);
    on<ProviderBookingStatusUpdateRequested>(_onStatusUpdateRequested);
  }

  Future<void> _onRequested(ProviderBookingsRequested event, Emitter<ProviderBookingsState> emit) async {
    emit(const ProviderBookingsLoading());

    final result = await getProviderBookingsUseCase(ProviderBookingsParams(event.providerUid));

    result.fold((failure) => emit(ProviderBookingsError(failure.message)), (bookings) => emit(ProviderBookingsLoaded(bookings)));
  }

  Future<void> _onStatusUpdateRequested(ProviderBookingStatusUpdateRequested event, Emitter<ProviderBookingsState> emit) async {
    emit(const ProviderBookingStatusUpdating());

    final result = await updateBookingStatusUseCase(UpdateBookingStatusParams(bookingId: event.bookingId, status: event.status));

    result.fold((failure) => emit(ProviderBookingStatusUpdateFailed(failure.message)), (_) async {
      emit(ProviderBookingStatusUpdated(event.status));
      // refresh the list after status change
      add(ProviderBookingsRequested(event.providerUid));
      if (event.status == 'completed') {
        await incrementCompletedJobsUseCase(event.providerUid);
      }
    });
  }
}
