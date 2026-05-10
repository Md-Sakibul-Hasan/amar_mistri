import 'package:cloudflare/cloudflare.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/cloudflare_config.dart';
import '../errors/exceptions.dart';

class CloudflareR2Service {
  late final R2API _r2;

  CloudflareR2Service() {
    _r2 = R2API(
      accountId: CloudflareConfig.accountId,
      credentials: R2Credentials(
        accessKeyId: CloudflareConfig.r2AccessKeyId,
        secretAccessKey: CloudflareConfig.r2SecretAccessKey,
      ),
    );
  }

  /// Uploads [file] to R2 under `profiles/{uid}/avatar.{ext}` and returns
  /// the public URL (with a cache-busting timestamp query parameter).
  Future<String> uploadProfilePhoto({
    required String uid,
    required XFile file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final safeExt = ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)
        ? ext
        : 'jpg';
    final key = 'profiles/$uid/avatar.$safeExt';
    final contentType = switch (safeExt) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };

    final response = await _r2.putObject(
      bucket: CloudflareConfig.r2BucketName,
      key: key,
      content: DataTransmit<XFile>(data: file),
      contentType: contentType,
    );

    if (!response.isSuccessful) {
      throw ServerException(
        'Image upload failed: ${response.error?.toString() ?? 'Unknown error'}',
      );
    }

    // Cache-busting so Flutter's NetworkImage fetches the fresh file.
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${CloudflareConfig.r2PublicBaseUrl}/$key?v=$ts';
  }

  void dispose() => _r2.dispose();
}
