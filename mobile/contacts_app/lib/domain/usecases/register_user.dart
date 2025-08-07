import 'package:contacts_app/core/resources/data_state.dart';
import 'package:contacts_app/domain/entities/login_reponse.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<DataState<LoginResponse>> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}