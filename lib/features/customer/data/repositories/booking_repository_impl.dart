import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_request.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  const BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createBooking(BookingRequest request) async {
    try {
      await remoteDataSource.createBooking(request);
      return const Right(null);
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}
