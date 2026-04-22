import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
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
      return AppUserModel.fromFirestore(doc.data()!);
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
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'A server error occurred.');
    }
  }

  @override
  Future<void> logout() async {
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
}
