import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AuthProvider {
  // DummyJSON pakai username, bukan email
  Future<Response> login({required String username, required String password}) {
    return ApiClient.post(
      ApiConstants.login,
      data: {'username': username, 'password': password, 'expiresInMins': 60},
    );
  }

  Future<Response> getMe() => ApiClient.get(ApiConstants.me);

  Future<Response> refreshToken(String refreshToken) => ApiClient.post(
    ApiConstants.refresh,
    data: {'refreshToken': refreshToken, 'expiresInMins': 60},
  );
}
