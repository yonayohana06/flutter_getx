import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class UserProvider {
  Future<Response> getProfile() => ApiClient.get(ApiConstants.profile);

  Future<Response> updateProfile(Map<String, dynamic> data) =>
      ApiClient.put(ApiConstants.updateProfile, data: data);
}
