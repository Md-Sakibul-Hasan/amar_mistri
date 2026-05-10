import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/cloudflare_r2_service.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class UploadProfilePhotoParams {
  final String uid;
  final XFile file;
  const UploadProfilePhotoParams({required this.uid, required this.file});
}

class UploadProfilePhotoUseCase {
  final AuthRepository repository;
  final CloudflareR2Service r2Service;

  const UploadProfilePhotoUseCase({
    required this.repository,
    required this.r2Service,
  });

  Future<Either<Failure, AppUser>> call(UploadProfilePhotoParams params) async {
    try {
      final photoUrl = await r2Service.uploadProfilePhoto(
        uid: params.uid,
        file: params.file,
      );
      return await repository.updatePhotoUrl(photoUrl);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
