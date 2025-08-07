// lib/core/errors/failures.dart
abstract class Failure {
  final String message;
  const Failure({required this.message});

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  String toString() => statusCode != null
      ? 'ServerFailure[$statusCode]: $message'
      : 'ServerFailure: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({required this.errors})
      : super(message: 'Validation failed');

  @override
  String toString() {
    final errorList = errors.entries.map((e) =>
    '${e.key}: ${e.value.join(", ")}'
    ).join('\n');
    return 'ValidationFailure:\n$errorList';
  }
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}