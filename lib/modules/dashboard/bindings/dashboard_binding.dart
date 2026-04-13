import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductProvider>(() => ProductProvider());
    Get.lazyPut<ProductRepository>(() => ProductRepository(Get.find()));
    Get.lazyPut<DashboardController>(() => DashboardController(Get.find()));
  }
}
