import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:shifaa/core/api/dio_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo_impl.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:shifaa/features/auth/data/repos/auth_repo_impl.dart';
import 'package:shifaa/features/auth/domain/repos/auth_repo.dart';
import 'package:shifaa/features/auth/domain/usecases/register_patient_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_otp_usecase.dart';
// import 'package:shifaa/features/auth/domain/usecases/verify_password_usecase.dart';

import 'package:shifaa/features/appointments/data/data_sources/doctor_details/doctor_remote_data_soucre.dart';
import 'package:shifaa/features/appointments/data/data_sources/doctor_details/doctor_remote_data_soucre_impl.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_details_repo/doctor_repo.dart';
import 'package:shifaa/features/appointments/domain/repos/doctor_details_repo/doctor_repo_impl.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_doctor_details_use_case.dart';

// ✅ Doctor Schedule Imports
import 'package:shifaa/features/appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source.dart';
import 'package:shifaa/features/appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source_impl.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_doctor_schedule_use_case.dart';

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

  // Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<DioConsumer>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => SendOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  // getIt.registerLazySingleton(() => VerifyPasswordUseCase(getIt<AuthRepository>()));

  // Doctor Feature
  getIt.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(getIt<DioConsumer>()),
  );

  getIt.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(getIt<DoctorRemoteDataSource>()),
  );

  getIt.registerLazySingleton(
    () => GetDoctorDetailsUseCase(getIt<DoctorRepository>()),
  );

  // ✅ Doctor Schedule Feature
  getIt.registerLazySingleton<DoctorScheduleRemoteDataSource>(
    () => DoctorScheduleRemoteDataSourceImpl(getIt<DioConsumer>()),
  );

  getIt.registerLazySingleton<DoctorScheduleRepository>(
    () => DoctorScheduleRepositoryImpl(getIt<DoctorScheduleRemoteDataSource>()),
  );

  getIt.registerLazySingleton(
    () => GetDoctorScheduleUseCase(getIt<DoctorScheduleRepository>()),
  );
}
