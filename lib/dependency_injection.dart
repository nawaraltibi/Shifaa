import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shifaa/core/platform/network_info.dart';
import 'package:shifaa/core/services/database_service.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_local_data_source.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:shifaa/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:shifaa/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_previous_appointments.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_upcoming_appointments.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
import 'package:shifaa/features/home/data/datasources/home_local_data_source.dart';
import 'package:shifaa/features/home/data/datasources/home_remote_data_source.dart';
import 'package:shifaa/features/home/data/repositories/home_repository_impl.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_previous_appointment_usecase.dart';
import 'package:shifaa/features/home/domain/usecases/get_home_upcoming_appointment_usecase.dart';
import 'package:shifaa/features/home/presentation/manager/home_cubit.dart';
import 'package:shifaa/features/search/data/datasources/doctor_remote_data_source.dart';
import 'package:shifaa/features/search/data/datasources/specialty_remote_data_source.dart';
import 'package:shifaa/features/search/data/repositories/doctor_repository_impl.dart';
import 'package:shifaa/features/search/data/repositories/specialty_repository_impl.dart';
import 'package:shifaa/features/search/domain/repositories/doctor_repository.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_doctors_usecase.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/specialty_details/data/datasources/specialty_details_remote_data_source.dart';
import 'package:shifaa/features/specialty_details/data/repositories/specialty_details_repository_impl.dart';
import 'package:shifaa/features/specialty_details/domain/repositories/specialty_details_repository.dart';
import 'package:shifaa/features/specialty_details/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:shifaa/features/specialty_details/presentation/manager/specialty_details_cubit.dart';
import 'package:shifaa/features/user_info/data/datasources/user_info_remote_data_source.dart';
import 'package:shifaa/features/user_info/data/repositories/user_info_repository_impl.dart';
import 'package:shifaa/features/user_info/domain/repositories/user_info_repository.dart';
import 'package:shifaa/features/user_info/domain/usecases/get_user_info_usecase.dart';
import 'package:shifaa/features/user_info/presentation/manager/user_info_cubit.dart';

final sl = GetIt.instance;

Future<String?> getTokenFromStorage() async {
  // 2. استخدم الكلاس الذي بنيته لجلب التوكن
  return await SharedPrefsHelper.instance.getToken();
}

Future<void> setupServiceLocatorAshour() async {
  // ================== Features - Search ==================
  sl.registerFactory(
    () => SearchCubit(
      searchForSpecialtiesUseCase: sl(),
      searchForDoctorsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => SearchForSpecialtiesUseCase(sl()));
  sl.registerLazySingleton(() => SearchForDoctorsUseCase(sl()));
  sl.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DoctorRepositoryAshour>(
    () => DoctorRepositoryImplAshour(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SpecialtyRemoteDataSource>(
    () => SpecialtyRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<DoctorRemoteDataSourceAshour>(
    () => DoctorRemoteDataSourceImplAshour(dio: sl()),
  );

  // ================== Features - Home ==================
sl.registerFactory(() => HomeCubit(
  getUpcomingAppointmentUsecase: sl(),
  getPreviousAppointmentUsecase: sl(),
));

sl.registerLazySingleton(() => GetHomeUpcomingAppointmentUsecase(sl()));
sl.registerLazySingleton(() => GetHomePreviousAppointmentUsecase(sl()));

sl.registerLazySingleton<HomeRepository>(
  () => HomeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo:  sl()),
);

sl.registerLazySingleton<HomeRemoteDataSource>(
  () => HomeRemoteDataSourceImpl(dio: sl()),
);

sl.registerLazySingleton<HomeLocalDataSource>(
  () => HomeLocalDataSourceImpl(databaseService: sl()),
);

//region UserInfo Feature Dependencies

// Cubit
sl.registerFactory(() => UserInfoCubit(sl()));

// Usecase
sl.registerLazySingleton(() => GetUserInfoUsecase(sl()));

// Repository
sl.registerLazySingleton<UserInfoRepository>(
    () => UserInfoRepositoryImpl(remoteDataSource: sl()));

// DataSource
sl.registerLazySingleton<UserInfoRemoteDataSource>(
    () => UserInfoRemoteDataSourceImpl(dio: sl()));

// Helper
// قم بتسجيل الـ SharedPreferencesHelper إذا لم تكن قد فعلت ذلك بالفعل
// sl.registerLazySingleton(() => SharedPreferencesHelper());

//endregion




//region SpecialtyDetails Feature Dependencies

// Cubit
sl.registerFactory(() => SpecialtyDetailsCubit(sl()));

// Usecase
sl.registerLazySingleton(() => GetSpecialtyDoctorsUsecase(sl()));

// Repository
sl.registerLazySingleton<SpecialtyDetailsRepository>(
    () => SpecialtyDetailsRepositoryImpl(remoteDataSource: sl()));

// DataSource
sl.registerLazySingleton<SpecialtyDetailsRemoteDataSource>(
    () => SpecialtyDetailsRemoteDataSourceImpl(dio: sl()));

//endregion



  // ================== Features - Appointments ==================
  sl.registerFactory(
    () => AppointmentsCubit(
      getUpcomingAppointmentsUseCase: sl(),
      getPreviousAppointmentsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUpcomingAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetPreviousAppointmentsUseCase(sl()));
  sl.registerLazySingleton<AppointmentRepositoryAshour>(
    () => AppointmentRepositoryImplAshour(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AppointmentRemoteDataSourceAshour>(
    () => AppointmentRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AppointmentLocalDataSource>(
    () => AppointmentLocalDataSourceImpl(databaseService: sl()),
  );

  // ================== Core / External ==================
  sl.registerLazySingleton(() => DatabaseService.instance);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Connectivity());
}
