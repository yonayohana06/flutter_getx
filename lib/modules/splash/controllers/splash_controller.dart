// lib/modules/splash/controllers/splash_controller.dart
import 'package:flutter_getx/core/services/auth_service.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    final storage = Get.find<StorageService>();
    if (storage.isLoggedIn) {
      await Get.find<AuthService>().init();
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
