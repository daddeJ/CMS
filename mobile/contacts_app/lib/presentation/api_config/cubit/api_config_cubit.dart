import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/config/api_config.dart';

part 'api_config_state.dart';

class ApiConfigCubit extends Cubit<ApiConfigState> {
  ApiConfigCubit() : super(ApiConfigInitial());

  Future<void> loadConfig() async {
    await ApiConfig.loadConfig();
    emit(ApiConfigLoaded(ApiConfig.baseUrl));
  }

  Future<void> updateConfig(String url) async {
    emit(ApiConfigSaving());
    await ApiConfig.configure(url: url);
    emit(ApiConfigSaved(ApiConfig.baseUrl));
  }
}
