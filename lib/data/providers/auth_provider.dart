import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AuthProvider {
  Future<Response> login({
    required String email,
    required String password,
  }) =>
      ApiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) =>
      ApiClient.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

  Future<Response> logout() => ApiClient.post(ApiConstants.logout);

  Future<Response> refreshToken(String refreshToken) =>
      ApiClient.post(ApiConstants.refresh, data: {'refresh_token': refreshToken});
}
