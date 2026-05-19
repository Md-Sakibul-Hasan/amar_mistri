import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/customer/domain/entities/customer_booking.dart';
import '../../../../features/customer/domain/usecases/get_provider_bookings_usecase.dart';

part 'provider_bookings_event.dart';
part 'provider_bookings_state.dart';

class ProviderBookingsBloc
    extends Bloc<ProviderBookingsEvent, ProviderBookingsState> {
  final GetProviderBookingsUseCase getProviderBookingsUseCase;

  ProviderBookingsBloc({required this.getProviderBookingsUseCase})
    : super(const ProviderBookingsInitial()) {
    on<ProviderBookingsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    ProviderBookingsRequested event,
    Emitter<ProviderBookingsState> emit,
  ) async {
    emit(const ProviderBookingsLoading());

    final result = await getProviderBookingsUseCase(
      ProviderBookingsParams(event.providerUid),
    );

    result.fold(
      (failure) => emit(ProviderBookingsError(failure.message)),
      (bookings) => emit(ProviderBookingsLoaded(bookings)),
    );
  }
}
