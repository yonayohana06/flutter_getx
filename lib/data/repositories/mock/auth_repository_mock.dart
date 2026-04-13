import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../../models/user_model.dart';
import '../auth_repository_base.dart';

class AuthRepositoryMock implements AuthRepositoryBase {
  static const _fakeUser = UserModel(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    phone: '+81 965-431-3024',
    gender: 'female',
    image: 'https://dummyjson.com/icon/emilys/128',
  );

  static const _fakeAccessToken = 'fake-access-token-mock-12345';
  static const _fakeRefreshToken = 'fake-refresh-token-mock-12345';
  static const _validUsername = 'emilys';
  static const _validPassword = 'emilyspass';

  @override
  Future<AuthResponse?> login({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username != _validUsername || password != _validPassword) {
      throw ServerException(message: 'Invalid credentials', statusCode: 400);
    }

    final storage = Get.find<StorageService>();
    await storage.saveToken(_fakeAccessToken);
    await storage.saveRefreshToken(_fakeRefreshToken);
    await storage.saveUser(_fakeUser.toJson());

    return const AuthResponse(
      accessToken: _fakeAccessToken,
      refreshToken: _fakeRefreshToken,
      user: _fakeUser,
    );
  }

  @override
  Future<UserModel?> getMe() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _fakeUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final storage = Get.find<StorageService>();
    await storage.removeToken();
    await storage.removeRefreshToken();
    await storage.removeUser();
  }
}
