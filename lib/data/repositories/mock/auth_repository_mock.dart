// lib/data/repositories/mock/auth_repository_mock.dart

import 'package:flutter_getx/core/errors/exceptions.dart';
import 'package:flutter_getx/data/repositories/auth_repository_base.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../models/user_model.dart';

class AuthRepositoryMock extends AuthRepositoryBase {
  // Fake user data
  static const _fakeUser = UserModel(
    id: 1,
    name: 'Budi Santoso',
    email: 'budi@mail.com',
    phone: '08123456789',
  );

  static const _fakeToken = 'fake-token-mock-12345';

  // Kredensial yang "valid" untuk testing
  static const _validEmail = 'budi@mail.com';
  static const _validPassword = '12345678';

  @override
  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulasi validasi kredensial
    if (email != _validEmail || password != _validPassword) {
      throw ServerException(
        message: 'Email atau password salah',
        statusCode: 401,
      );
    }

    // Simpan ke storage seperti implementasi asli
    final storage = Get.find<StorageService>();
    await storage.saveToken(_fakeToken);
    await storage.saveUser(_fakeUser.toJson());

    return AuthResponse(token: _fakeToken, user: _fakeUser);
  }

  @override
  Future<AuthResponse?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final newUser = UserModel(id: 2, name: name, email: email);

    final storage = Get.find<StorageService>();
    await storage.saveToken(_fakeToken);
    await storage.saveUser(newUser.toJson());

    return AuthResponse(token: _fakeToken, user: newUser);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final storage = Get.find<StorageService>();
    await storage.removeToken();
    await storage.removeUser();
  }
}
