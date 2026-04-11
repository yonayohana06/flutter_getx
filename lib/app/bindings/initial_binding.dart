import 'package:flutter/foundation.dart';
import 'package:flutter_getx/data/repositories/auth_repository_base.dart';
import 'package:flutter_getx/data/repositories/mock/auth_repository_mock.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/repositories/auth_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<AuthProvider>(() => AuthProvider(), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepositoryBase>(
      () => kDebugMode
          ? AuthRepositoryMock()
          : AuthRepository(Get.find<AuthProvider>()),
      fenix: true,
    );

    // Services
    Get.lazyPut<AuthService>(
      () => AuthService(Get.find<AuthRepositoryBase>()),
      fenix: true,
    );
  }
}
