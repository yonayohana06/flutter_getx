import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../routes/app_routes.dart';
import '../../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(message: 'Connection timed out. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message =
            err.response?.data?['message'] ?? 'Server error occurred';

        if (statusCode == 401) {
          // Auto logout on 401
          Get.offAllNamed(AppRoutes.LOGIN);
          throw UnauthorizedException(message: message);
        }

        throw ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.connectionError:
        throw const NetworkException();

      default:
        throw ServerException(
          message: err.message ?? 'Unknown error occurred',
        );
    }
  }
}
