import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_constants.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? photoUrl;

  // Provider-specific fields
  final List<String>? services;
  final int? experienceYears;
  final String? skills;
  final String? serviceArea;
  final String? nidNumber;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.photoUrl,
    this.services,
    this.experienceYears,
    this.skills,
    this.serviceArea,
    this.nidNumber,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    role,
    photoUrl,
    services,
    experienceYears,
    skills,
    serviceArea,
    nidNumber,
  ];

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? photoUrl,
    List<String>? services,
    int? experienceYears,
    String? skills,
    String? serviceArea,
    String? nidNumber,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      services: services ?? this.services,
      experienceYears: experienceYears ?? this.experienceYears,
      skills: skills ?? this.skills,
      serviceArea: serviceArea ?? this.serviceArea,
      nidNumber: nidNumber ?? this.nidNumber,
    );
  }
}
