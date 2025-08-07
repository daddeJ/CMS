import 'dart:convert';
import '../../domain/entities/login_reponse.dart';
import 'user_model.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.token,
    required super.refreshToken,
    required super.expiresAt,
    required UserModel user,
  }) : super(user: user);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'user': (user as UserModel).toJson(),
    };
  }

  factory LoginResponseModel.fromEntity(LoginResponse loginResponse) {
    return LoginResponseModel(
      token: loginResponse.token,
      refreshToken: loginResponse.refreshToken,
      expiresAt: loginResponse.expiresAt,
      user: UserModel.fromEntity(loginResponse.user),
    );
  }

  @override
  LoginResponse toEntity() {
    return LoginResponse(
      token: token,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      user: (user as UserModel).toEntity(),
    );
  }
}