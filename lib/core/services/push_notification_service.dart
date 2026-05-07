import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants/app_constants.dart';
import '../../firebase_options.dart';

const AndroidNotificationChannel _androidNotificationChannel =
    AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for booking, account, and order updates.',
      importance: Importance.high,
    );

Future<void> initializeFirebaseApp() async {
  if (Firebase.apps.isNotEmpty) {
    return;
  }

  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    return;
  }

  await Firebase.initializeApp();
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeFirebaseApp();
  debugPrint('[FCM] Background message received: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _messaging = messaging,
       _localNotifications = localNotifications;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _initializeLocalNotifications();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint(
      '[FCM] Notification permission status: '
      '${settings.authorizationStatus.name}',
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
    _messaging.onTokenRefresh.listen(
      (token) => attachTokenToUser(token: token),
    );
    _firebaseAuth.authStateChanges().listen(_handleAuthStateChanged);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOpenedMessage(initialMessage);
    }

    await syncTokenForCurrentUser();
    _isInitialized = true;
  }

  Future<void> _initializeLocalNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(settings: settings);

    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.createNotificationChannel(
      _androidNotificationChannel,
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('[FCM] Foreground message received: ${message.messageId}');

    final notification = message.notification;
    if (notification == null) {
      return;
    }

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidNotificationChannel.id,
          _androidNotificationChannel.name,
          channelDescription: _androidNotificationChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  void _handleOpenedMessage(RemoteMessage message) {
    debugPrint(
      '[FCM] Notification opened: ${message.messageId}, data: ${message.data}',
    );
  }

  Future<void> _handleAuthStateChanged(User? user) async {
    if (user == null) {
      return;
    }

    await syncTokenForCurrentUser();
  }

  Future<String?> getCurrentToken() {
    return _messaging.getToken();
  }

  Future<void> syncTokenForCurrentUser() async {
    final token = await _messaging.getToken();
    if (token == null) {
      debugPrint('[FCM] Token not available yet.');
      return;
    }

    await attachTokenToUser(token: token);
  }

  Future<void> attachTokenToUser({
    required String token,
    String? userId,
  }) async {
    final resolvedUserId = userId ?? _firebaseAuth.currentUser?.uid;
    if (resolvedUserId == null) {
      debugPrint('[FCM] Skipping token sync because no user is logged in.');
      return;
    }

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(resolvedUserId)
        .set({
          'fcmTokens': FieldValue.arrayUnion([token]),
          'lastNotificationTokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    debugPrint('[FCM] Token synced for user $resolvedUserId.');
  }

  Future<void> detachTokenFromUser({String? userId}) async {
    final resolvedUserId = userId ?? _firebaseAuth.currentUser?.uid;
    if (resolvedUserId == null) {
      debugPrint('[FCM] Skipping token removal because no user is logged in.');
      return;
    }

    final token = await getCurrentToken();
    if (token == null) {
      debugPrint('[FCM] Token not available for removal.');
      return;
    }

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(resolvedUserId)
        .set({
          'fcmTokens': FieldValue.arrayRemove([token]),
          'lastNotificationTokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    debugPrint('[FCM] Token removed for user $resolvedUserId.');
  }
}