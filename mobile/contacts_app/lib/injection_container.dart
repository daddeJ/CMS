// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/config/api_config.dart';
import 'core/utils/logger.dart';

// Data
import 'data/datasource/local/auth_local_data_source_impl.dart';
import 'data/datasource/remote/auth_remote_data_source.dart';
import 'data/datasource/remote/auth_remote_data_source_impl.dart';
import 'data/datasource/remote/contact_remote_data_source.dart';
import 'data/datasource/remote/contact_remote_data_source_impl.dart';
import 'data/datasource/local/auth_local_data_source.dart';
import 'data/repositories_impl/auth_repository_impl.dart';
import 'data/repositories_impl/contact_repository_impl.dart';

// Domain
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/contact_repository.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/register_user.dart';
import 'domain/usecases/get_cached_user.dart';
import 'domain/usecases/fetch_contact_list.dart';
import 'domain/usecases/add_contact.dart';
import 'domain/usecases/update_contact.dart';
import 'domain/usecases/delete_item_contact.dart';

// Presentation
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/contact/cubit/contact_cubit.dart';
import 'presentation/api_config/cubit/api_config_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initCore();
  await _initAuth();
  await _initContacts();
  await _initApiConfig();
}

Future<void> _initCore() async {
  // External packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio()
    ..options = BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    )
    ..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    )));

  // Core utilities
  sl.registerLazySingleton(() => AppLogger());
}

Future<void> _initAuth() async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetCachedUser(sl()));

  // Cubit
  sl.registerFactory(() => AuthCubit(
    loginUser: sl(),
    registerUser: sl(),
    getCachedUser: sl(),
  ));
}

Future<void> _initContacts() async {
  // Data sources
  sl.registerLazySingleton<ContactRemoteDataSource>(
        () => ContactRemoteDataSourceImpl(dio: sl(), authLocalDataSource: sl()),
  );

  // Repository
  sl.registerLazySingleton<ContactRepository>(
        () => ContactRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchContactList(sl()));
  sl.registerLazySingleton(() => AddContact(sl()));
  sl.registerLazySingleton(() => UpdateContact(sl()));
  sl.registerLazySingleton(() => DeleteItemContact(sl()));

  // Cubit
  sl.registerFactory(() => ContactCubit(
    fetchContactList: sl(),
    addContact: sl(),
    updateContact: sl(),
    deleteItemContact: sl(),
  ));
}

Future<void> _initApiConfig() async {
  sl.registerFactory(() => ApiConfigCubit());
}
