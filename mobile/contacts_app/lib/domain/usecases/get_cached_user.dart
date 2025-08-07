import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUser {
  final AuthRepository repository;

  GetCachedUser(this.repository);

  Future<User?> call() {
    return repository.getCachedUser();
  }
}
