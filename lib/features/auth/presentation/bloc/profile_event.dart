part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSaveRequested extends ProfileEvent {
  final String name;
  final String phone;
  final List<String>? services;
  final int? experienceYears;
  final String? skills;
  final String? serviceArea;
  final String? nidNumber;

  const ProfileSaveRequested({
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
