import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shifaa/core/platform/network_info.dart';
import 'package:shifaa/core/services/database_service.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_local_data_source.dart';
import 'package:shifaa/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:shifaa/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:shifaa/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_previous_appointments.dart';
import 'package:shifaa/features/appointments/domain/usecases/get_upcoming_appointments.dart';
import 'package:shifaa/features/appointments/presentation/manager/appointments_cubit.dart';
import 'package:shifaa/features/search/data/datasources/doctor_remote_data_source.dart';
import 'package:shifaa/features/search/data/datasources/specialty_remote_data_source.dart';
import 'package:shifaa/features/search/data/repositories/doctor_repository_impl.dart';
import 'package:shifaa/features/search/data/repositories/specialty_repository_impl.dart';
import 'package:shifaa/features/search/domain/repositories/doctor_repository.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_doctors_usecase.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';

final sl = GetIt.instance;


Future<String?> getTokenFromStorage() async {
  return '4|A5ToOet7ApV3jigDuDHObrKAEHsHCwKIFnWNsfrq5411cc6a';
}


Future<void> setupServiceLocator() async {
  // ================== Features - Search ==================
  sl.registerFactory(() => SearchCubit(
        searchForSpecialtiesUseCase: sl(),
        searchForDoctorsUseCase: sl(), 
      ));
  sl.registerLazySingleton(() => SearchForSpecialtiesUseCase(sl()));
  sl.registerLazySingleton(() => SearchForDoctorsUseCase(sl())); 
  sl.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DoctorRepository>( 
    () => DoctorRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SpecialtyRemoteDataSource>(
    () => SpecialtyRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<DoctorRemoteDataSource>( 
    () => DoctorRemoteDataSourceImpl(dio: sl()),
  );

  // ================== Features - Appointments ==================
  sl.registerFactory(() => AppointmentsCubit(
    getUpcomingAppointmentsUseCase: sl(),
    getPreviousAppointmentsUseCase: sl(),
  ));
  sl.registerLazySingleton(() => GetUpcomingAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetPreviousAppointmentsUseCase(sl()));
  sl.registerLazySingleton<AppointmentRepository>(
 
    () => AppointmentRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(), 
    ),
  );
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AppointmentLocalDataSource>(
    () => AppointmentLocalDataSourceImpl(databaseService: sl()),
  );

  // ================== Core / External ==================
  sl.registerLazySingleton(() => DatabaseService.instance);
  
 
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://shifaa-backend.onrender.com/api/',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getTokenFromStorage();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false, 
        request: true,
      ),
    );
    
    return dio;
  });
}