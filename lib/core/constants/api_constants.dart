abstract class ApiConstants {
  // Base URLs - ganti sesuai environment
  static const String baseUrl     = 'https://api.example.com/v1';
  static const String baseUrlDev  = 'https://dev-api.example.com/v1';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Endpoints - Auth
  static const String login    = '/auth/login';
  static const String register = '/auth/register';
  static const String logout   = '/auth/logout';
  static const String refresh  = '/auth/refresh';

  // Endpoints - User
  static const String profile       = '/user/profile';
  static const String updateProfile = '/user/profile/update';
}
