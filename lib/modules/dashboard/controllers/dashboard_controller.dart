import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../routes/app_routes.dart';

class DashboardController extends GetxController {
  final ProductRepository _productRepository;

  DashboardController(this._productRepository);

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final currentUser = Rx<UserModel?>(null);
  final selectedIndex = 0.obs;
  final products = <ProductModel>[].obs;

  int _skip = 0;
  static const int _limit = 10;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    fetchProducts();
  }

  void _loadUser() {
    currentUser.value = Get.find<AuthService>().currentUser.value;
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _skip = 0;
      _hasMore = true;
      products.clear();
    }
    if (!_hasMore || isLoading.value) return;

    isLoading.value = true;
    try {
      final response = await _productRepository.getProducts(
        limit: _limit,
        skip: _skip,
      );
      products.addAll(response.products);
      _skip += response.products.length;
      _hasMore = response.hasMore;
    } on Exception catch (e) {
      final message = switch (e) {
        ServerException() => (e).message,
        NetworkException() => (e).message,
        _ => 'Something went wrong',
      };
      AppHelpers.showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final response = await _productRepository.getProducts(
        limit: _limit,
        skip: _skip,
      );
      products.addAll(response.products);
      _skip += response.products.length;
      _hasMore = response.hasMore;
    } on Exception catch (e) {
      final message = switch (e) {
        ServerException() => (e).message,
        NetworkException() => (e).message,
        _ => 'Something went wrong',
      };
      AppHelpers.showError(message);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void changeTab(int index) => selectedIndex.value = index;

  Future<void> logout() async {
    final confirmed = await AppHelpers.showConfirm(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      icon: Icons.logout_rounded,
      confirmColor: const Color(0xFFE53935),
    );
    if (confirmed == true) {
      await Get.find<AuthService>().logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
