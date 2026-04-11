import 'package:flutter/material.dart';
import 'package:flutter_getx/core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class DashboardController extends GetxController {
  final UserRepository _userRepository;

  DashboardController(this._userRepository);

  // ── State ──────────────────────────────────────────────────
  final isLoading = false.obs;
  final currentUser = Rx<UserModel?>(null);
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final authService = Get.find<AuthService>();
    currentUser.value = authService.currentUser.value;
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final user = await _userRepository.getProfile();
      currentUser.value = user;
    } on ServerException catch (e) {
      AppHelpers.showError(e.message);
    } on NetworkException {
      AppHelpers.showError('No internet connection');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) => selectedIndex.value = index;

  Future<void> logout() async {
    final confirmed = await AppHelpers.showConfirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      icon: Icons.logout_rounded,
      confirmColor: AppColors.error,
    );
    if (confirmed == true) {
      await Get.find<AuthService>().logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
