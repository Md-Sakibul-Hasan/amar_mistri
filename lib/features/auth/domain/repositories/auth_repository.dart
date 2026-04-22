import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_user.dart';
import '../../../../core/constants/app_constants.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required UserRole role,
    List<String>? services,
    int? experienceYears,
    String? skills,
    String? serviceArea,
    String? nidNumber,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AppUser>> getCurrentUser();
}
