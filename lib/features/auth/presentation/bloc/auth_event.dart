part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
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

  const AuthRegisterRequested({
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

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthUserUpdated extends AuthEvent {
  final AppUser user;
  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}
