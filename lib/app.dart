import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/core/router/app_router.dart';
import 'package:smart_campus_operations_system/core/theme/app_theme.dart';

/// Root MaterialApp.router widget.
class SmartCampusApp extends ConsumerStatefulWidget {
  const SmartCampusApp({super.key});

  @override
  ConsumerState<SmartCampusApp> createState() => _SmartCampusAppState();
}

class _SmartCampusAppState extends ConsumerState<SmartCampusApp> {
  @override
  void initState() {
    super.initState();
    // Check auth status on app start
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
