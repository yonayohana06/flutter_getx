import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_getx/data/repositories/auth_repository_base.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final AuthRepositoryBase _repository;

  AuthService(this._repository);

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isLoggedIn => Get.find<StorageService>().isLoggedIn;

  // Dipanggil di SplashController saat app start
  Future<void> init() async {
    log('init auth');
    final userData = Get.find<StorageService>().userData;
    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  Future<void> login(String username, String password) async {
    final response = await _repository.login(
      username: username,
      password: password,
    );
    if (response != null) {
      currentUser.value = response.user;
    }
  }

  // Fetch fresh data dari API
  Future<void> fetchMe() async {
    final result = await _repository.getMe();
    if (result != null) {
      currentUser.value = null;
      currentUser.value = result;
      await Get.find<StorageService>().saveUser(result.toJson());
    }
  }

  Future<void> logout() async {
    // Hapus cache image user sebelum logout
    final imageUrl = currentUser.value?.image;
    if (imageUrl != null) {
      await CachedNetworkImageProvider(imageUrl).evict();
    }
    await _repository.logout();
    currentUser.value = null;
  }
}
