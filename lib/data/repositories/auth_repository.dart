import 'package:flutter_getx/data/repositories/auth_repository_base.dart';
import 'package:get/get.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/storage_service.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class AuthRepository extends AuthRepositoryBase {
  final AuthProvider _provider;

  AuthRepository(this._provider);

  @override
  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _provider.login(email: email, password: password);
      final authResponse = AuthResponse.fromJson(res.data);

      final storage = Get.find<StorageService>();
      await storage.saveToken(authResponse.token);
      await storage.saveUser(authResponse.user.toJson());

      return authResponse;
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  @override
  Future<AuthResponse?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _provider.register(
        name: name,
        email: email,
        password: password,
      );
      final authResponse = AuthResponse.fromJson(res.data);

      final storage = Get.find<StorageService>();
      await storage.saveToken(authResponse.token);
      await storage.saveUser(authResponse.user.toJson());

      return authResponse;
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _provider.logout();
    } catch (_) {
      // Tetap logout lokal meski request gagal
    } finally {
      final storage = Get.find<StorageService>();
      await storage.removeToken();
      await storage.removeUser();
    }
  }
}
