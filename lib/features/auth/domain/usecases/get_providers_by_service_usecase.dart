import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetProvidersByServiceUseCase
    implements UseCase<List<AppUser>, ServiceParams> {
  final AuthRepository repository;
  const GetProvidersByServiceUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppUser>>> call(ServiceParams params) {
    return repository.getUsersByService(params.service);
  }
}

class ServiceParams extends Equatable {
  final String service;
  const ServiceParams({required this.service});

  @override
  List<Object> get props => [service];
}
