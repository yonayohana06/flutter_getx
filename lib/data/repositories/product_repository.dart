import '../../core/errors/exceptions.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductRepository {
  final ProductProvider _provider;

  ProductRepository(this._provider);

  Future<ProductsResponse> getProducts({int limit = 10, int skip = 0}) async {
    try {
      final res = await _provider.getProducts(limit: limit, skip: skip);
      return ProductsResponse.fromJson(res.data);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final res = await _provider.getProductById(id);
      return ProductModel.fromJson(res.data);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  Future<ProductsResponse> searchProducts(String query) async {
    try {
      final res = await _provider.searchProducts(query);
      return ProductsResponse.fromJson(res.data);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }
}
