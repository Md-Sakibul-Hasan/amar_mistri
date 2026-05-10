import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfileUseCase
    implements UseCase<AppUser, UpdateUserProfileParams> {
  final AuthRepository repository;
  const UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(
      name: params.name,
      phone: params.phone,
      services: params.services,
      experienceYears: params.experienceYears,
      skills: params.skills,
      serviceArea: params.serviceArea,
      nidNumber: params.nidNumber,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String name;
  final String phone;
  final List<String>? services;
  final int? experienceYears;
  final String? skills;
  final String? serviceArea;
  final String? nidNumber;

  const UpdateUserProfileParams({
    required this.name,
    required this.phone,
    this.services,
    this.experienceYears,
    this.skills,
    this.serviceArea,
    this.nidNumber,
  });

  @override
  List<Object?> get props => [
    name,
    phone,
    services,
    experienceYears,
    skills,
    serviceArea,
    nidNumber,
  ];
}
