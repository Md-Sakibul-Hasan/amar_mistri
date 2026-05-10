import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_profile_photo_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUserProfileUseCase updateUserProfile;
  final UploadProfilePhotoUseCase uploadProfilePhoto;

  ProfileBloc({
    required this.updateUserProfile,
    required this.uploadProfilePhoto,
  }) : super(const ProfileInitial()) {
    on<ProfileSaveRequested>(_onSaveRequested);
    on<ProfilePhotoUploadRequested>(_onPhotoUploadRequested);
  }

  Future<void> _onSaveRequested(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileSaving());
    final result = await updateUserProfile(
      UpdateUserProfileParams(
        name: event.name,
        phone: event.phone,
        services: event.services,
        experienceYears: event.experienceYears,
        skills: event.skills,
        serviceArea: event.serviceArea,
        nidNumber: event.nidNumber,
      ),
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileSaved(user)),
    );
  }

  Future<void> _onPhotoUploadRequested(
    ProfilePhotoUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfilePhotoUploading());
    final result = await uploadProfilePhoto(
      UploadProfilePhotoParams(uid: event.uid, file: event.file),
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileSaved(user)),
    );
  }
}
