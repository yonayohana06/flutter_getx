import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _repository;

  ProductDetailController(this._repository);

  late ProductModel product;
  late final PageController pageController;
  late final ScrollController scrollController;

  final isLoading = false.obs;
  final selectedImageIndex = 0.obs;
  final isTitleVisible = false.obs;

  // Threshold kapan title mulai muncul
  // 320 = expandedHeight SliverAppBar
  static const double _titleThreshold = 260.0;

  @override
  void onInit() {
    super.onInit();
    // Tampil data dari arguments dulu (sudah ada dari list)
    product = Get.arguments as ProductModel;
    pageController = PageController();
    scrollController = ScrollController()..addListener(_onScroll);
    // Fetch ulang untuk dapat data lengkap (reviews, dimensions, dll)
    fetchDetail();
  }

  void _onScroll() {
    final shouldShow = scrollController.offset > _titleThreshold;
    if (shouldShow != isTitleVisible.value) {
      isTitleVisible.value = shouldShow;
    }
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    try {
      final result = await _repository.getProductById(product.id);
      product = result;
      // Refresh UI
      update();
    } on Exception catch (e) {
      final message = switch (e) {
        ServerException() => (e).message,
        NetworkException() => (e).message,
        _ => 'Failed to load product detail',
      };
      AppHelpers.showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) => selectedImageIndex.value = index;

  void selectImage(int index) {
    selectedImageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
