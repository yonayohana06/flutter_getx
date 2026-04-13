import 'package:get/get.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/storage_service.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'auth_repository_base.dart';

class AuthRepository implements AuthRepositoryBase {
  final AuthProvider _provider;

  AuthRepository(this._provider);

  @override
  Future<AuthResponse?> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _provider.login(username: username, password: password);
      final authResponse = AuthResponse.fromJson(res.data);

      final storage = Get.find<StorageService>();
      await storage.saveToken(authResponse.accessToken);
      await storage.saveRefreshToken(authResponse.refreshToken);
      await storage.saveUser(authResponse.user.toJson());

      return authResponse;
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  @override
  Future<UserModel?> getMe() async {
    try {
      final res = await _provider.getMe();
      return UserModel.fromJson(res.data);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  @override
  Future<void> logout() async {
    // DummyJSON tidak punya logout endpoint
    // cukup hapus token lokal
    final storage = Get.find<StorageService>();
    await storage.removeToken();
    await storage.removeRefreshToken();
    await storage.removeUser();
  }
}
