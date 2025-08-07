import 'package:contacts_app/data/models/login_response_model.dart';

import '../../../core/resources/data_state.dart';
import '../../../domain/entities/login_reponse.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
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
}