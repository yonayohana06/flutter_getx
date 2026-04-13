import 'package:flutter/material.dart';
import 'package:flutter_getx/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
// import '../../../data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final AuthService _authService;

  ProfileController(this._authService);

  // ── Form ───────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // ── State ──────────────────────────────────────────────────
  final isLoading = false.obs;
  final isEditing = false.obs;
  final user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(_authService.currentUser, (u) {
      user.value = u;
    });
    _loadFromService();
    fetchMe();
  }

  void _loadFromService() {
    user.value = _authService.currentUser.value;
    // _populateForm();
  }

  Future<void> fetchMe() async {
    isLoading.value = true;
    try {
      await _authService.fetchMe();
    } on Exception catch (e) {
      final message = switch (e) {
        ServerException() => (e).message,
        NetworkException() => (e).message,
        _ => 'Failed to load profile',
      };
      AppHelpers.showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await AppHelpers.showConfirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      icon: Icons.logout_rounded,
      confirmColor: const Color(0xFFE53935),
    );
    if (confirmed == true) {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  void _populateForm() {
    nameCtrl.text = user.value?.username ?? '';
    phoneCtrl.text = user.value?.phone ?? '';
  }

  // Future<void> fetchProfile() async {
  //   isLoading.value = true;
  //   try {
  //     final result = await _authService.getProfile();
  //     user.value = result;
  //     _populateForm();
  //   } on ServerException catch (e) {
  //     AppHelpers.showError(e.message);
  //   } on NetworkException {
  //     AppHelpers.showError('No internet connection');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void toggleEdit() {
    if (isEditing.value) {
      // Cancel: reset to original
      _populateForm();
    }
    isEditing.toggle();
  }

  // Future<void> saveProfile() async {
  //   if (!formKey.currentState!.validate()) return;

  //   isLoading.value = true;
  //   try {
  //     final updated = await _authService.updateProfile({
  //       'name': nameCtrl.text.trim(),
  //       'phone': phoneCtrl.text.trim(),
  //     });
  //     user.value = updated;

  //     // Sync to AuthService
  //     Get.find<AuthService>().currentUser.value = updated;

  //     isEditing.value = false;
  //     AppHelpers.showSuccess('Profile updated successfully!');
  //   } on ServerException catch (e) {
  //     AppHelpers.showError(e.message);
  //   } on NetworkException {
  //     AppHelpers.showError('No internet connection');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  String? validateName(String? v) => Validators.required(v, fieldName: 'Name');
  String? validatePhone(String? v) => Validators.phone(v);

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
