part of 'api_config_cubit.dart';

abstract class ApiConfigState extends Equatable {
  const ApiConfigState();

  @override
  List<Object?> get props => [];
}

class ApiConfigInitial extends ApiConfigState {}

class ApiConfigLoaded extends ApiConfigState {
  final String baseUrl;

  const ApiConfigLoaded(this.baseUrl);

  @override
  List<Object?> get props => [baseUrl];
}

class ApiConfigSaving extends ApiConfigState {}

class ApiConfigSaved extends ApiConfigState {
  final String baseUrl;

  const ApiConfigSaved(this.baseUrl);

  @override
  List<Object?> get props => [baseUrl];
}
