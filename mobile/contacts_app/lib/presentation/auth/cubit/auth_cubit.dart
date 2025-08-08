import 'package:contacts_app/domain/usecases/register_user.dart';
import 'package:contacts_app/domain/usecases/get_cached_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/usecases/login_user.dart';
import '../../../../domain/entities/user.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final GetCachedUser getCachedUser;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.getCachedUser,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = await getCachedUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final loginResponse = await loginUser(email: email, password: password);
      final userModel = UserModel.fromEntity(loginResponse.data!.user);
      emit(AuthAuthenticated(userModel));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError("Unexpected error during login"));
    }
  }

  Future<void> register(
      String email,
      String password,
      String firstname,
      String lastname,
      ) async {
    emit(AuthLoading());
    try {
      await registerUser(
        email: email,
        password: password,
        firstName: firstname,
        lastName: lastname,
      );

      emit(const AuthRegisterSuccess());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError("Unexpected error during registration"));
    }
  }

  User? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }

  bool get isAuthenticated {
    return state is AuthAuthenticated;
  }
}