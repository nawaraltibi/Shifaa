import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:shifaa/core/api/dio_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:shifaa/features/auth/data/repos/auth_repo_impl.dart';
import 'package:shifaa/features/auth/domain/repos/auth_repo.dart';
import 'package:shifaa/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/register_patient_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_password_usecase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Dio setup
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = EndPoint.baseUrl;
    return dio;
  });

  // DioConsumer
  getIt.registerLazySingleton(() => DioConsumer(dio: getIt<Dio>()));

  // Remote Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<DioConsumer>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  // getIt.registerLazySingleton(() => VerifyPasswordUseCase(getIt<AuthRepository>()));
}
