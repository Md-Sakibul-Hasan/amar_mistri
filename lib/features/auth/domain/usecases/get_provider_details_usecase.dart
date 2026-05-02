import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetProviderDetailsUseCase implements UseCase<AppUser, UidParams> {
  final AuthRepository repository;
  const GetProviderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(UidParams params) {
    return repository.getProviderDetails(params.uid);
  }
}

class UidParams extends Equatable {
  final String uid;
  const UidParams({required this.uid});

  @override
  List<Object> get props => [uid];
}
