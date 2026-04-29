import 'package:dio/dio.dart';
import 'package:smart_campus_operations_system/core/constants/api_endpoints.dart';
import 'package:smart_campus_operations_system/core/network/api_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Factory for creating a configured [Dio] instance.
class DioClient {
  DioClient._();

  static Dio create(SharedPreferences prefs) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      ApiInterceptor(prefs),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    ]);

    return dio;
  }
}
