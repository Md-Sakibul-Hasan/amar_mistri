import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_request.dart';
import '../entities/customer_booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> createBooking(BookingRequest request);
  Future<Either<Failure, List<CustomerBooking>>> getCustomerBookings();
  Future<Either<Failure, List<CustomerBooking>>> getProviderBookings(String providerUid);
  Future<Either<Failure, void>> updateBookingStatus(String bookingId, String status);

  Future<Either<Failure, void>> updateProviderCompletedJobs(String providerUid);
}
