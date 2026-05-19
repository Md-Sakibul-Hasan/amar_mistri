import 'dart:async';

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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _bookingSubscription;
  bool _bookingListenerInitialLoadDone = false;

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
      await stopBookingListener();
      return;
    }

    await syncTokenForCurrentUser();

    // If the user is a provider, start listening for new booking requests.
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['role'] == 'provider') {
        startBookingListener(user.uid);
      }
    } catch (e) {
      debugPrint('[FCM] Error checking role for booking listener: $e');
    }
  }

  Future<String?> getCurrentToken() {
    return _messaging.getToken();
  }

  /// Starts a real-time Firestore listener for new bookings assigned to
  /// [providerUid]. Each newly added document fires a local notification.
  /// Safe to call multiple times — cancels any existing subscription first.
  void startBookingListener(String providerUid) {
    _bookingSubscription?.cancel();
    _bookingListenerInitialLoadDone = false;
    debugPrint('[FCM] Starting booking listener for provider $providerUid');

    _bookingSubscription = _firestore
        .collection('Bookings')
        .where('providerUid', isEqualTo: providerUid)
        .snapshots()
        .listen(
          (snapshot) {
            if (!_bookingListenerInitialLoadDone) {
              // Skip the initial snapshot — those are existing documents.
              _bookingListenerInitialLoadDone = true;
              return;
            }
            for (final change in snapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                final data = change.doc.data();
                if (data != null) {
                  _showNewBookingLocalNotification(data);
                }
              }
            }
          },
          onError: (Object e) => debugPrint('[FCM] Booking listener error: $e'),
        );
  }

  Future<void> stopBookingListener() async {
    await _bookingSubscription?.cancel();
    _bookingSubscription = null;
    _bookingListenerInitialLoadDone = false;
    debugPrint('[FCM] Booking listener stopped.');
  }

  Future<void> _showNewBookingLocalNotification(
    Map<String, dynamic> data,
  ) async {
    final customerName = (data['customerName'] as String?) ?? 'A customer';
    final service = (data['service'] as String?) ?? 'a service';
    final area = (data['area'] as String?) ?? '';
    final priority = (data['priority'] as String?) ?? '';
    final bookingId = (data['bookingId'] as String?) ?? '';

    final priorityLabel = priority == 'urgent'
        ? '🚨 Urgent'
        : priority == 'high'
        ? '⚡ High'
        : '';
    final body = [
      '$customerName booked you for $service',
      if (area.isNotEmpty) 'in $area',
      if (priorityLabel.isNotEmpty) '[$priorityLabel]',
    ].join(' ');

    await _localNotifications.show(
      id: bookingId.hashCode,
      title: 'New Booking Request',
      body: body,
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
    debugPrint('[FCM] Local notification shown for booking $bookingId');
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
