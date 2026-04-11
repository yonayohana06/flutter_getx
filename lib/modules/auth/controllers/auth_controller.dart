import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth_repository_base.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepositoryBase _repository;

  AuthController(this._repository);

  // ── Form Keys ──────────────────────────────────────────────
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // ── Controllers ────────────────────────────────────────────
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  // ── State ──────────────────────────────────────────────────
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmHidden = true.obs;

  // ── Validators ─────────────────────────────────────────────
  String? validateEmail(String? v) => Validators.email(v);
  String? validatePassword(String? v) => Validators.password(v);
  String? validateName(String? v) => Validators.required(v, fieldName: 'Name');
  String? validateConfirm(String? v) =>
      Validators.confirmPassword(v, passwordCtrl.text);

  void togglePassword() => isPasswordHidden.toggle();
  void toggleConfirmPassword() => isConfirmHidden.toggle();

  // ── Login ──────────────────────────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _repository.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } on ServerException catch (e) {
      AppHelpers.showError(e.message);
    } on NetworkException catch (e) {
      AppHelpers.showError(e.message);
    } catch (_) {
      AppHelpers.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register ───────────────────────────────────────────────
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _repository.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } on ServerException catch (e) {
      AppHelpers.showError(e.message);
    } on NetworkException catch (e) {
      AppHelpers.showError(e.message);
    } catch (_) {
      AppHelpers.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }
}
