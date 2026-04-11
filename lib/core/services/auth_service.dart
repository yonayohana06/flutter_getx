import 'package:flutter_getx/data/repositories/auth_repository_base.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final AuthRepositoryBase _repository;

  AuthService(this._repository);

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isLoggedIn => Get.find<StorageService>().isLoggedIn;

  Future<void> loadUser() async {
    final storage = Get.find<StorageService>();
    final userData = storage.userData;
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  Future<bool> login(String email, String password) async {
    final result = await _repository.login(email: email, password: password);
    if (result != null) {
      currentUser.value = result.user;
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _repository.logout();
    currentUser.value = null;
  }
}
