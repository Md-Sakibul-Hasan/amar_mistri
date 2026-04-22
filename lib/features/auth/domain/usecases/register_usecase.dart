import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AppUser, RegisterParams> {
  final AuthRepository repository;
  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      role: params.role,
      services: params.services,
      experienceYears: params.experienceYears,
      skills: params.skills,
      serviceArea: params.serviceArea,
      nidNumber: params.nidNumber,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String phone;
  final UserRole role;
  final List<String>? services;
  final int? experienceYears;
  final String? skills;
  final String? serviceArea;
  final String? nidNumber;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    this.services,
    this.experienceYears,
    this.skills,
    this.serviceArea,
    this.nidNumber,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    phone,
    role,
    services,
    experienceYears,
    skills,
    serviceArea,
    nidNumber,
  ];
}
