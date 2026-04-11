import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider _provider;

  UserRepository(this._provider);

  Future<UserModel> getProfile() async {
    try {
      final res = await _provider.getProfile();
      return UserModel.fromJson(res.data['data']);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final res = await _provider.updateProfile(data);
      return UserModel.fromJson(res.data['data']);
    } on ServerException catch (e) {
      throw ServerException(message: e.message, statusCode: e.statusCode);
    } on NetworkException {
      throw const NetworkException();
    }
  }
}
