abstract class ApiConstants {
  // Base URL DummyJSON
  static const String baseUrl = 'https://dummyjson.com';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Endpoints - Auth
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';

  // Endpoints - Products
  static const String products = '/products';
  static const String productSearch = '/products/search';

  // Endpoints - User
  static const String users = '/users';

  // Pagination
  static const int perPage = 10;
}
