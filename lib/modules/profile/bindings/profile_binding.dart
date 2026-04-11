import 'package:get/get.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/user_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find()));
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find()));
  }
}
