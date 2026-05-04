import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/features/notifications/background_handler.dart';
import 'package:smart_campus_operations_system/features/notifications/notification_service.dart';
import 'package:smart_campus_operations_system/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (required before any other Firebase service)
  await Firebase.initializeApp();

  // Register the top-level background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize local SQLite database
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  // Initialize FCM + local notifications
  await NotificationService().initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        databaseHelperProvider.overrideWithValue(dbHelper),
      ],
      child: const SmartCampusApp(),
    ),
  );
}
