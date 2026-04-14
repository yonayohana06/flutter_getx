import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';

class ProductDetailController extends GetxController {
  late final ProductModel product;
  final pageController = PageController();

  // Index foto yang sedang aktif di image gallery
  final selectedImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil product dari arguments
    product = Get.arguments as ProductModel;
  }

  void selectImage(int index) => selectedImageIndex.value = index;

  void onThumbnailTap(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    selectImage(index);
  }
}
