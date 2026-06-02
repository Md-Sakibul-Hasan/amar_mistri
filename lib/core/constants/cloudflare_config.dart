// ⚠️ SECURITY NOTE: These R2 credentials grant write access to your bucket.
// For production apps, generate presigned upload URLs server-side and
// never ship HMAC credentials in the client binary.
class CloudflareConfig {
  CloudflareConfig._();

  static const String accountId = '600acc72b8e29e918ff125faa7fca51c';
  static const String r2AccessKeyId = '9a06b06f9f94b8a566382d85afa9df42';
  static const String r2SecretAccessKey = '0084c6cf8c11a0667ef7f906a6d680bc2f17678917e769419fa9d2f33111e174';
  static const String r2BucketName = 'sheba';
  static const String r2PublicBaseUrl = 'https://pub-44a1a831d3e740d6bd767cddecea36f2.r2.dev';
}
