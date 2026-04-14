import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx/core/constants/api_constants.dart';
import 'package:flutter_getx/routes/app_routes.dart';
import 'package:get/get.dart' hide Response;
import '../../services/storage_service.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storage;

  // Dio instance terpisah khusus untuk refresh
  // supaya tidak infinite loop
  final _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  AuthInterceptor(this._storage);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      if (kDebugMode) {
        print('RESPONSE STATUS: ${response.statusCode}');
        print('RESPONSE DATA: ${response.data}');
      }
    }
    handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Kalau 401 dan bukan dari endpoint refresh itu sendiri
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiConstants.refresh) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request original dengan token baru
          final response = await _retry(err.requestOptions, newToken);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Refresh gagal → logout
        _forceLogout();
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    _refreshDio.interceptors.addAll([ErrorInterceptor(), LoggingInterceptor()]);
    final refreshToken = _storage.refreshToken;
    if (refreshToken == null) return null;

    final response = await _refreshDio.post(
      ApiConstants.refresh,
      data: {'refreshToken': refreshToken, 'expiresInMins': 60},
    );

    final newAccessToken = response.data['accessToken'] as String;
    final newRefreshToken = response.data['refreshToken'] as String;

    // Simpan token baru
    await _storage.saveToken(newAccessToken);
    await _storage.saveRefreshToken(newRefreshToken);

    return newAccessToken;
  }

  Future<Response> _retry(RequestOptions requestOptions, String token) {
    return _refreshDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }

  void _forceLogout() {
    _storage.clearAll();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
