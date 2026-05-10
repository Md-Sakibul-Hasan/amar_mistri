import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateUserProfileUseCase updateUserProfile;

  ProfileBloc({required this.updateUserProfile})
    : super(const ProfileInitial()) {
    on<ProfileSaveRequested>(_onSaveRequested);
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
}
