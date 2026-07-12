import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/app_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AppUserModel> login({required String email, required String password});

  Future<AppUserModel> register({
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

  Future<void> logout();

  Future<AppUserModel> getCurrentUser();
  Future<List<AppUserModel>> getUsersByService(String service);
  Future<AppUserModel> getProviderDetails(String uid);

  Future<AppUserModel> updateUserProfile({
    required String name,
    required String phone,
    List<String>? services,
    int? experienceYears,
    String? skills,
    String? serviceArea,
    String? nidNumber,
  });

  Future<AppUserModel> updatePhotoUrl(String photoUrl);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final PushNotificationService pushNotificationService;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.pushNotificationService,
  });

  @override
  Future<AppUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .get();
      if (!doc.exists) throw const AuthException('User data not found.');
      await pushNotificationService.syncTokenForCurrentUser();
      final user = AppUserModel.fromFirestore(doc.data()!);
      if (user.name.isEmpty) {
        final fallback = credential.user!.displayName ?? credential.user!.email!.split('@').first;
        return user.copyWith(name: fallback);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed.');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<AppUserModel> register({
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
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      final user = AppUserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        services: services,
        experienceYears: experienceYears,
        skills: skills,
        serviceArea: serviceArea,
        nidNumber: nidNumber,
      );
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toFirestore());
      await pushNotificationService.syncTokenForCurrentUser();
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<void> logout() async {
    await pushNotificationService.detachTokenFromUser();
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUserModel> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) throw const AuthException('No user logged in.');
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();
      if (!doc.exists) throw const AuthException('User data not found.');
      await pushNotificationService.syncTokenForCurrentUser();
      final user = AppUserModel.fromFirestore(doc.data()!);
      if (user.name.isEmpty) {
        final fallback = firebaseUser.displayName ?? firebaseUser.email!.split('@').first;
        return user.copyWith(name: fallback);
      }
      return user;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<List<AppUserModel>> getUsersByService(String service) async {
    try {
      final querySnapshot = await firestore
          .collection(AppConstants.usersCollection)
          .where('services', arrayContains: service)
          .get();
      // For simplicity, return the first matching provider. Adjust as needed.
      return querySnapshot.docs
          .map((doc) => AppUserModel.fromFirestore(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<AppUserModel> getProviderDetails(String uid) async {
    try {
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      if (!doc.exists) throw const AuthException('Provider not found.');
      return AppUserModel.fromFirestore(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<AppUserModel> updateUserProfile({
    required String name,
    required String phone,
    List<String>? services,
    int? experienceYears,
    String? skills,
    String? serviceArea,
    String? nidNumber,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw const AuthException('No user logged in.');
      final updateData = <String, dynamic>{
        'name': name,
        'phone': phone,
        'services': services ?? [],
        'experienceYears': experienceYears,
        'skills': skills,
        'serviceArea': serviceArea,
        'nidNumber': nidNumber,
      };
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(updateData);
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      return AppUserModel.fromFirestore(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<AppUserModel> updatePhotoUrl(String photoUrl) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw const AuthException('No user logged in.');
      await firestore.collection(AppConstants.usersCollection).doc(uid).update({
        'photoUrl': photoUrl,
      });
      final doc = await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      return AppUserModel.fromFirestore(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }
}

/// Temporary mock — replace with real implementation after Firebase is connected.
class MockAuthDataSource implements AuthRemoteDataSource {
  AppUserModel? _currentUser;

  // Seeded test accounts: email → (password, user)
  final _store = <String, ({String password, AppUserModel user})>{};

  @override
  Future<AppUserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final entry = _store[email];
    if (entry == null || entry.password != password) {
      throw const AuthException('Invalid email or password.');
    }
    _currentUser = entry.user;
    return _currentUser!;
  }

  @override
  Future<AppUserModel> register({
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
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_store.containsKey(email)) {
      throw const AuthException('Email already registered.');
    }
    final user = AppUserModel(
      uid: Uuid().v4(),
      name: name,
      email: email,
      phone: phone,
      role: role,
      services: services,
      experienceYears: experienceYears,
      skills: skills,
      serviceArea: serviceArea,
      nidNumber: nidNumber,
    );
    _store[email] = (password: password, user: user);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<AppUserModel> getCurrentUser() async {
    if (_currentUser == null) throw const AuthException('No user logged in.');
    return _currentUser!;
  }

  @override
  Future<List<AppUserModel>> getUsersByService(String service) async {
    final providers = _store.values
        .where((entry) => entry.user.services?.contains(service) == true)
        .map((entry) => entry.user)
        .toList();
    return providers;
  }

  @override
  Future<AppUserModel> getProviderDetails(String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final entry = _store.values
        .cast<({String password, AppUserModel user})?>()
        .firstWhere((e) => e?.user.uid == uid, orElse: () => null);
    if (entry == null) throw const AuthException('Provider not found.');
    return entry.user;
  }

  @override
  Future<AppUserModel> updateUserProfile({
    required String name,
    required String phone,
    List<String>? services,
    int? experienceYears,
    String? skills,
    String? serviceArea,
    String? nidNumber,
  }) async {
    if (_currentUser == null) throw const AuthException('No user logged in.');
    final updated = AppUserModel(
      uid: _currentUser!.uid,
      name: name,
      email: _currentUser!.email,
      phone: phone,
      role: _currentUser!.role,
      photoUrl: _currentUser!.photoUrl,
      services: services,
      experienceYears: experienceYears,
      skills: skills,
      serviceArea: serviceArea,
      nidNumber: nidNumber,
    );
    _store[_currentUser!.email] = (
      password: _store[_currentUser!.email]!.password,
      user: updated,
    );
    _currentUser = updated;
    return _currentUser!;
  }

  @override
  Future<AppUserModel> updatePhotoUrl(String photoUrl) async {
    if (_currentUser == null) throw const AuthException('No user logged in.');
    final updated = AppUserModel(
      uid: _currentUser!.uid,
      name: _currentUser!.name,
      email: _currentUser!.email,
      phone: _currentUser!.phone,
      role: _currentUser!.role,
      photoUrl: photoUrl,
      services: _currentUser!.services,
      experienceYears: _currentUser!.experienceYears,
      skills: _currentUser!.skills,
      serviceArea: _currentUser!.serviceArea,
      nidNumber: _currentUser!.nidNumber,
    );
    _store[_currentUser!.email] = (
      password: _store[_currentUser!.email]!.password,
      user: updated,
    );
    _currentUser = updated;
    return _currentUser!;
  }
}
