import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user';
  static const String _themeKey = 'theme';
  static const String _langKey = 'language';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // ── Access Token ───────────────────────────────────────────
  String? get token => _box.read<String>(_tokenKey);
  Future<void> saveToken(String token) => _box.write(_tokenKey, token);
  Future<void> removeToken() => _box.remove(_tokenKey);

  // ── Refresh Token ──────────────────────────────────────────
  String? get refreshToken => _box.read<String>(_refreshTokenKey);
  Future<void> saveRefreshToken(String token) =>
      _box.write(_refreshTokenKey, token);
  Future<void> removeRefreshToken() => _box.remove(_refreshTokenKey);

  // ── User ───────────────────────────────────────────────────
  Map<String, dynamic>? get userData =>
      _box.read<Map<String, dynamic>>(_userKey);
  Future<void> saveUser(Map<String, dynamic> user) =>
      _box.write(_userKey, user);
  Future<void> removeUser() => _box.remove(_userKey);

  // ── Theme ──────────────────────────────────────────────────
  String get theme => _box.read<String>(_themeKey) ?? 'system';
  Future<void> saveTheme(String theme) => _box.write(_themeKey, theme);

  // ── Language ───────────────────────────────────────────────
  String get language => _box.read<String>(_langKey) ?? 'en';
  Future<void> saveLanguage(String lang) => _box.write(_langKey, lang);

  // ── Clear All ──────────────────────────────────────────────
  Future<void> clearAll() => _box.erase();

  // ── Auth helper ────────────────────────────────────────────
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
