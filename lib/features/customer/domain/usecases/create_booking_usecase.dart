import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_request.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase implements UseCase<void, CreateBookingParams> {
  final BookingRepository repository;

  const CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateBookingParams params) {
    return repository.createBooking(params.request);
  }
}

class CreateBookingParams extends Equatable {
  final BookingRequest request;

  const CreateBookingParams({required this.request});

  @override
  List<Object?> get props => [request];
}
