import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor that injects the Bearer token and handles auth errors.
class ApiInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';

  ApiInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired or unauthorized — could trigger logout here
      _prefs.remove(_tokenKey);
    }
    handler.next(err);
  }
}
