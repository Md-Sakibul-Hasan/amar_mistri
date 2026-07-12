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
    super.ratings,
    super.totalRatings,
    super.totalReviews,
    super.completedJobs,
  });

  @override
  AppUserModel copyWith({
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
    double? ratings,
    int? totalRatings,
    int? totalReviews,
    int? completedJobs,
  }) {
    return AppUserModel(
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
      ratings: ratings ?? this.ratings,
      totalRatings: totalRatings ?? this.totalRatings,
      totalReviews: totalReviews ?? this.totalReviews,
      completedJobs: completedJobs ?? this.completedJobs,
    );
  }

  factory AppUserModel.fromFirestore(Map<String, dynamic> map) {
    return AppUserModel(
      uid: (map['uid'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      role: _roleFromString(map['role'] as String?),
      photoUrl: map['photoUrl'] as String?,
      services: (map['services'] as List<dynamic>?)?.cast<String>(),
      experienceYears: (map['experienceYears'] as num?)?.toInt(),
      skills: map['skills'] as String?,
      serviceArea: map['serviceArea'] as String?,
      nidNumber: map['nidNumber'] as String?,
      ratings: (map['ratings'] as num?)?.toDouble(),
      totalRatings: (map['totalRatings'] as num?)?.toInt(),
      totalReviews: (map['totalReviews'] as num?)?.toInt(),
      completedJobs: (map['completedJobs'] as num?)?.toInt(),
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
      if (_roleFromString(role.name) == UserRole.provider) 'ratings': 0.0,
      if (_roleFromString(role.name) == UserRole.provider) 'totalRatings': 0,
      if (_roleFromString(role.name) == UserRole.provider) 'totalReviews': 0,
      if (_roleFromString(role.name) == UserRole.provider) 'completedJobs': 0,
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
