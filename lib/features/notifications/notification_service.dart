import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for handling Firebase Cloud Messaging (FCM) push notifications.
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  bool _isInitialized = false;

  // --- flutter_local_notifications setup ---
  static const _channelId = 'campus_notifications';
  static const _channelName = 'Campus Notifications';
  static const _channelDesc = 'Push notifications for Smart Campus Operations';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification service.
  /// Call this once from [main] after Firebase.initializeApp().
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Configure flutter_local_notifications
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _localNotifications.initialize(initSettings);

      // Create the Android notification channel (required for Android 8+)
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // 2. Request FCM permissions
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3. Log the FCM token (useful during development)
      final token = await messaging.getToken();
      debugPrint('[Notifications] FCM Token: $token');

      // 4. Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 5. Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was launched from a terminated-state notification
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      debugPrint('[Notifications] Service initialized successfully.');
      _isInitialized = true;
    } catch (e) {
      debugPrint('[Notifications] Failed to initialize: $e');
    }
  }

  /// Shows a local notification when a message arrives in the foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint(
        '[Notifications] Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
        ),
      );
    }
  }

  /// Called when the user taps on a notification (app in background or terminated).
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('[Notifications] Notification tapped: ${message.data}');
    // TODO: Navigate to the relevant screen based on message.data
  }

  /// Returns the current FCM registration token.
  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /// Subscribe to a topic (e.g., 'announcements', 'all_users').
  Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('[Notifications] Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    debugPrint('[Notifications] Unsubscribed from topic: $topic');
  }

  /// Trigger a push notification via your backend / Cloud Function.
  /// Direct device-to-device messaging is not supported by FCM; notifications
  /// should be sent from a trusted server using the Firebase Admin SDK.
  Future<void> sendPushNotification(
    String title,
    String body, {
    required String topic,
  }) async {
    // Example: await dio.post('/api/notifications/send', data: {
    //   'topic': topic,
    //   'title': title,
    //   'body': body,
    // });
    debugPrint('[Notifications] 🚀 Requested push to topic "$topic"');
    debugPrint('[Notifications] Title: $title');
    debugPrint('[Notifications] Body:  $body');
  }
}
