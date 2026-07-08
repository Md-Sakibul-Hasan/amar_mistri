# sebaghar

A Flutter app for the Sebaghar marketplace.

## Getting Started

## Firebase Cloud Messaging

Firebase Cloud Messaging is now wired into app startup.

- `firebase_messaging` initializes during bootstrap in `main.dart`.
- Foreground notifications are displayed with `flutter_local_notifications`.
- Device tokens are saved to each logged-in user's Firestore document under `fcmTokens`.
- Android uses the `high_importance_channel` notification channel.

### Remaining Firebase Console Steps

1. Add the iOS `GoogleService-Info.plist` file to `ios/Runner/`.
2. In Firebase Console, upload an APNs authentication key or certificate for the iOS app.
3. Enable the Push Notifications capability in the iOS Runner target inside Xcode.
4. Send either notification messages or data messages that your backend handles explicitly.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
