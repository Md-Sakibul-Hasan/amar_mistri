import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer_booking.dart';
import '../repositories/booking_repository.dart';

class GetProviderBookingsUseCase
    implements UseCase<List<CustomerBooking>, ProviderBookingsParams> {
  final BookingRepository repository;

  const GetProviderBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CustomerBooking>>> call(
    ProviderBookingsParams params,
  ) {
    return repository.getProviderBookings(params.providerUid);
  }
}

class ProviderBookingsParams extends Equatable {
  final String providerUid;

  const ProviderBookingsParams(this.providerUid);

  @override
  List<Object?> get props => [providerUid];
}
