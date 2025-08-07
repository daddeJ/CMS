import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheAuthData({
    required UserModel user,
    required String token,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    await sharedPreferences.setString('auth_token', token);
    await sharedPreferences.setString('refresh_token', refreshToken);
    await sharedPreferences.setString('token_expiry', expiresAt.toIso8601String());
    await sharedPreferences.setString('user_data', jsonEncode(user.toJson()));
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString('auth_token');
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString('refresh_token');
  }

  @override
  Future<DateTime?> getTokenExpiry() async {
    final expiryString = sharedPreferences.getString('token_expiry');
    return expiryString != null ? DateTime.parse(expiryString) : null;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString('user_data');
    return userJson != null ? UserModel.fromJson(jsonDecode(userJson)) : null;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('refresh_token');
    await sharedPreferences.remove('token_expiry');
    await sharedPreferences.remove('user_data');
  }
}