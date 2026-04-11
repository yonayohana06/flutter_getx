// lib/data/repositories/auth_repository_base.dart

import '../models/user_model.dart';

abstract class AuthRepositoryBase {
  Future<AuthResponse?> login({
    required String email,
    required String password,
  });

  Future<AuthResponse?> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}
