import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/data/models/login_response_model.dart';
import 'package:contacts_app/domain/entities/login_reponse.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<DataState<LoginResponseModel>> call({
    required String email, required String password
  }) async {
    return await repository.login(email: email, password: password);
  }
}