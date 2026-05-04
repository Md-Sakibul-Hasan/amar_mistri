import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/customer_booking.dart';
import '../../domain/usecases/get_customer_bookings_usecase.dart';

part 'customer_bookings_event.dart';
part 'customer_bookings_state.dart';

class CustomerBookingsBloc
    extends Bloc<CustomerBookingsEvent, CustomerBookingsState> {
  final GetCustomerBookingsUseCase getCustomerBookingsUseCase;

  CustomerBookingsBloc({required this.getCustomerBookingsUseCase})
    : super(const CustomerBookingsInitial()) {
    on<CustomerBookingsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    CustomerBookingsRequested event,
    Emitter<CustomerBookingsState> emit,
  ) async {
    emit(const CustomerBookingsLoading());

    final result = await getCustomerBookingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(CustomerBookingsError(failure.message)),
      (bookings) => emit(CustomerBookingsLoaded(bookings)),
    );
  }
}
