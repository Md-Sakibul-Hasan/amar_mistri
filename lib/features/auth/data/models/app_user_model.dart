import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    super.photoUrl,
    super.services,
    super.experienceYears,
    super.skills,
    super.serviceArea,
    super.nidNumber,
  });

  factory AppUserModel.fromFirestore(Map<String, dynamic> map) {
    return AppUserModel(
      uid: (map['uid'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      role: _roleFromString(map['role'] as String?),
      photoUrl: map['photoUrl'] as String?,
      services: (map['services'] as List<dynamic>?)?.cast<String>(),
      experienceYears: map['experienceYears'] as int?,
      skills: map['skills'] as String?,
      serviceArea: map['serviceArea'] as String?,
      nidNumber: map['nidNumber'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'photoUrl': photoUrl,
      if (services != null) 'services': services,
      if (experienceYears != null) 'experienceYears': experienceYears,
      if (skills != null) 'skills': skills,
      if (serviceArea != null) 'serviceArea': serviceArea,
      if (nidNumber != null) 'nidNumber': nidNumber,
    };
  }

  static UserRole _roleFromString(String? value) {
    switch (value) {
      case 'provider':
        return UserRole.provider;
      case 'customer':
        return UserRole.customer;
      default:
        return UserRole.unknown;
    }
  }
}
