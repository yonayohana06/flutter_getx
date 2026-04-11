import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────── REQUEST ───────────');
      print('│ ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) print('│ Body: ${options.data}');
      print('└───────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────── RESPONSE ──────────');
      print('│ Status: ${response.statusCode}');
      print('│ Data: ${response.data}');
      print('└───────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────── ERROR ─────────────');
      print('│ ${err.message}');
      print('│ Response: ${err.response?.data}');
      print('└───────────────────────────────');
    }
    handler.next(err);
  }
}
