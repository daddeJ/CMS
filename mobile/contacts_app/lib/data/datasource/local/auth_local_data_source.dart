import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData({
    required UserModel user,
    required String token,
    required String refreshToken,
    required DateTime expiresAt,
  });

  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<DateTime?> getTokenExpiry();
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}