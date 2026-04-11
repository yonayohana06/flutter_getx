import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../constants/api_constants.dart';
import '../services/storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
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

    dio.interceptors.addAll([
      AuthInterceptor(Get.find<StorageService>()),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }

  // ── HTTP Methods ──────────────────────────────────────────
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      instance.get(path, queryParameters: queryParameters, options: options);

  static Future<Response> post(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      instance.post(path, data: data, options: options);

  static Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      instance.put(path, data: data, options: options);

  static Future<Response> patch(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      instance.patch(path, data: data, options: options);

  static Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      instance.delete(path, data: data, options: options);
}
