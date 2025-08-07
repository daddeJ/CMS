import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/data/models/login_response_model.dart';
import 'package:contacts_app/domain/entities/login_reponse.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<DataState<LoginResponseModel>> login({
    required String email,
    required String password
  });

  Future<DataState<LoginResponseModel>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<User?> getCachedUser();
}