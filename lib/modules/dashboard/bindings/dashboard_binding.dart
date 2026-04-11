import 'package:get/get.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/user_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find()));
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find()));
  }
}
