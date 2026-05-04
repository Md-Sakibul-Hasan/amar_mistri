import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_request.dart';
import '../entities/customer_booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> createBooking(BookingRequest request);
  Future<Either<Failure, List<CustomerBooking>>> getCustomerBookings();
}
