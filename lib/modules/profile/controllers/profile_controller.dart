import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserRepository _repository;

  ProfileController(this._repository);

  // ── Form ───────────────────────────────────────────────────
  final formKey   = GlobalKey<FormState>();
  final nameCtrl  = TextEditingController();
  final phoneCtrl = TextEditingController();

  // ── State ──────────────────────────────────────────────────
  final isLoading  = false.obs;
  final isEditing  = false.obs;
  final user       = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadFromService();
    fetchProfile();
  }

  void _loadFromService() {
    final authService = Get.find<AuthService>();
    user.value = authService.currentUser.value;
    _populateForm();
  }

  void _populateForm() {
    nameCtrl.text  = user.value?.name  ?? '';
    phoneCtrl.text = user.value?.phone ?? '';
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final result = await _repository.getProfile();
      user.value = result;
      _populateForm();
    } on ServerException catch (e) {
      AppHelpers.showError(e.message);
    } on NetworkException {
      AppHelpers.showError('No internet connection');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Cancel: reset to original
      _populateForm();
    }
    isEditing.toggle();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final updated = await _repository.updateProfile({
        'name' : nameCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
      });
      user.value = updated;

      // Sync to AuthService
      Get.find<AuthService>().currentUser.value = updated;

      isEditing.value = false;
      AppHelpers.showSuccess('Profile updated successfully!');
    } on ServerException catch (e) {
      AppHelpers.showError(e.message);
    } on NetworkException {
      AppHelpers.showError('No internet connection');
    } finally {
      isLoading.value = false;
    }
  }

  String? validateName(String? v)  => Validators.required(v, fieldName: 'Name');
  String? validatePhone(String? v) => Validators.phone(v);

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
