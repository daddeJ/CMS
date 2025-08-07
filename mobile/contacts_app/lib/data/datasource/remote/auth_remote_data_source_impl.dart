import 'dart:math';

import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/data/models/login_response_model.dart';
import 'package:dio/dio.dart';

import '../../../core/config/api_config.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<DataState<LoginResponseModel>> login({
    required String email,
    required String password}) async {
    try {
      final response = await dio.post('${ApiConfig.apiBaseUrl}/auth-api/api/Auth/login', data: {
        'email': email,
        'password': password,
      });
      final loginResponse =  LoginResponseModel.fromJson(response.data);
      return DataSuccess(loginResponse);
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
      final response = await dio.post('${ApiConfig.apiBaseUrl}/auth-api/api/Auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });
      final loginResponse = LoginResponseModel.fromJson(response.data);
      return DataSuccess(loginResponse);
    } on DioException catch (e)
    {
      return DataFailed(e);
    }

  }
}