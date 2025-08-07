import 'package:contacts_app/core/resources/data_state.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../datasource/remote/auth_remote_data_source.dart';
import '../datasource/local/auth_local_data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<DataState<LoginResponseModel>> login({
    required String email,
    required String password
  }) async {
    try {
      final loginResult = await remoteDataSource.login(email: email, password: password);
      if(loginResult.data == null) {
        return DataFailed(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Login failed: response data was null',
          ),
        );
      }
      final userModel = UserModel.fromEntity(loginResult.data!.user);

      await localDataSource.cacheAuthData(
        user: userModel,
        token: loginResult.data!.token,
        refreshToken: loginResult.data!.refreshToken,
        expiresAt: loginResult.data!.expiresAt,
      );
      return DataSuccess(loginResult.data!);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<LoginResponseModel>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final registerResult = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      await localDataSource.cacheAuthData(
        user: UserModel.fromEntity(registerResult.data!.user),
        token: registerResult.data!.token,
        refreshToken: registerResult.data!.refreshToken,
        expiresAt: registerResult.data!.expiresAt,
      );
      return DataSuccess(registerResult.data!);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
  @override
  Future<User?> getCachedUser() async {
    final userModel = await localDataSource.getCachedUser();
    return userModel?.toEntity();
  }
}