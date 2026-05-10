// ⚠️ SECURITY NOTE: These R2 credentials grant write access to your bucket.
// For production apps, generate presigned upload URLs server-side and
// never ship HMAC credentials in the client binary.
class CloudflareConfig {
  CloudflareConfig._();

  static const String accountId = '600acc72b8e29e918ff125faa7fca51c';
  static const String r2AccessKeyId = '83491059657b789687f6cd72a9402876';
  static const String r2SecretAccessKey =
      '682c1c17ab682401b0d3fca641b3e9266a3bac4954abd94194b70fa82040bec1';
  static const String r2BucketName = 'sheba';
  static const String r2PublicBaseUrl =
      'https://pub-44a1a831d3e740d6bd767cddecea36f2.r2.dev';
}
