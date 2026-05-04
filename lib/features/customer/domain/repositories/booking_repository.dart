import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_request.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> createBooking(BookingRequest request);
}
