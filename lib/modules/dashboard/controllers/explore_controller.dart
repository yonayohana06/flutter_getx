import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ExploreController extends GetxController {
  final ProductRepository _repository;

  ExploreController(this._repository);

  final searchCtrl = TextEditingController();
  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final searchQuery = ''.obs;
  final hasSearched = false.obs;

  // Debounce timer supaya tidak hit API tiap ketik
  Worker? _debounce;

  @override
  void onInit() {
    super.onInit();
    // Dengarkan perubahan searchQuery dengan debounce 500ms
    _debounce = debounce(searchQuery, (String query) {
      if (query.trim().isNotEmpty) {
        _search(query.trim());
      } else {
        products.clear();
        hasSearched.value = false;
      }
    }, time: const Duration(milliseconds: 500));
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
    products.clear();
    hasSearched.value = false;
  }

  Future<void> _search(String query) async {
    isLoading.value = true;
    hasSearched.value = true;
    try {
      final response = await _repository.searchProducts(query);
      products.value = response.products;
    } on Exception catch (e) {
      final message = switch (e) {
        ServerException() => (e).message,
        NetworkException() => (e).message,
        _ => 'Search failed. Please try again.',
      };
      AppHelpers.showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    _debounce?.dispose();
    super.onClose();
  }
}
