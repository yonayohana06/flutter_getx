import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class ProductProvider {
  Future<Response> getProducts({int limit = 10, int skip = 0}) {
    return ApiClient.get(
      ApiConstants.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );
  }

  Future<Response> getProductById(int id) {
    return ApiClient.get('${ApiConstants.products}/$id');
  }

  Future<Response> searchProducts(String query, {int limit = 10}) {
    return ApiClient.get(
      ApiConstants.productSearch,
      queryParameters: {'q': query, 'limit': limit},
    );
  }
}
