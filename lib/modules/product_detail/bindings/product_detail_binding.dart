import 'package:get/get.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductProvider>(() => ProductProvider());
    Get.lazyPut<ProductRepository>(() => ProductRepository(Get.find()));
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(Get.find()),
    );
  }
}
