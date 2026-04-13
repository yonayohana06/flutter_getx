// lib/data/repositories/auth_repository_base.dart

import '../models/user_model.dart';

abstract class AuthRepositoryBase {
  Future<AuthResponse?> login({
    required String username,
    required String password,
  });

  Future<UserModel?> getMe();

  Future<void> logout();
}
