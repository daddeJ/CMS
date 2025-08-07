import 'package:equatable/equatable.dart';
import 'user.dart';

class LoginResponse extends Equatable {
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;

  const LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  @override
  List<Object> get props => [token, refreshToken, expiresAt, user];

  @override
  String toString() {
    return 'LoginResponse(token: $token, refreshToken: $refreshToken, expiresAt: $expiresAt, user: $user)';
  }
}