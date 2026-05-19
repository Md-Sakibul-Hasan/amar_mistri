import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class UpdateBookingStatusUseCase
    implements UseCase<void, UpdateBookingStatusParams> {
  final BookingRepository repository;

  const UpdateBookingStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBookingStatusParams params) =>
      repository.updateBookingStatus(params.bookingId, params.status);
}

class UpdateBookingStatusParams extends Equatable {
  final String bookingId;
  final String status;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  @override
  List<Object?> get props => [bookingId, status];
}
