import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────── REQUEST ───────────');
      print('│ ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) log('│ Body: ${options.data}');
      print('└───────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final data = jsonEncode(response.data);
      print('┌─────────── RESPONSE ──────────');
      print('│ Status: ${response.statusCode}');
      log(
        '│ Data:\n\t $data\n'
        '└───────────────────────────────',
      );
      print('└───────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────── ERROR ─────────────');
      print('│ ${err.message}');
      log('│ Response: ${err.response?.data}');
      print('└───────────────────────────────');
    }
    handler.next(err);
  }
}
