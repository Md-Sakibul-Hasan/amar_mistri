import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<AppUser, NoParams> {
  final AuthRepository repository;
  const GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
