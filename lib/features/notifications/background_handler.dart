import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Background message handler for Firebase Messaging.
/// Must be a top-level function annotated with @pragma('vm:entry-point').
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be initialized in the background isolate separately.
  await Firebase.initializeApp();

  debugPrint('[Notifications] Background message received: ${message.messageId}');
  debugPrint('[Notifications] Title: ${message.notification?.title}');
  debugPrint('[Notifications] Body:  ${message.notification?.body}');

  // TODO: Add background processing here, e.g.:
  // - Show a local notification via flutter_local_notifications
  // - Sync data to local SQLite database
  // - Update app badge count
}
