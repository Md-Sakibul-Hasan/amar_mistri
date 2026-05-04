import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer_booking.dart';
import '../repositories/booking_repository.dart';

class GetCustomerBookingsUseCase
    implements UseCase<List<CustomerBooking>, NoParams> {
  final BookingRepository repository;

  const GetCustomerBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CustomerBooking>>> call(NoParams params) {
    return repository.getCustomerBookings();
  }
}
