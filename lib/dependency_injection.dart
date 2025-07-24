import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// استيراد ملفات التخصصات
import 'package:shifaa/features/search/data/datasources/specialty_remote_data_source.dart';
import 'package:shifaa/features/search/data/repositories/specialty_repository_impl.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';

// ==== استيراد الملفات الجديدة الخاصة بالأطباء ====
import 'package:shifaa/features/search/data/datasources/doctor_remote_data_source.dart';
import 'package:shifaa/features/search/data/repositories/doctor_repository_impl.dart';
import 'package:shifaa/features/search/domain/repositories/doctor_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_doctors_usecase.dart';
// ==========================================

import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';


final sl = GetIt.instance;


Future<String?> getTokenFromStorage() async {
  // final prefs = await SharedPreferences.getInstance();
  // return prefs.getString('user_token');
  
  return '1|zhYIPOLGxdnoKfMJnx1YXTiWVTHku2JKy0TJj7B8dfb717d7';
}


Future<void> setupServiceLocator() async {
  // ================== Features - Search ==================

  // Cubit
  // تم تحديث هذا السطر ليمرر الـ UseCase الخاص بالأطباء أيضاً
  sl.registerFactory(() => SearchCubit(
        searchForSpecialtiesUseCase: sl(),
        searchForDoctorsUseCase: sl(), // الإضافة الجديدة
      ));

  // Use Cases
  sl.registerLazySingleton(() => SearchForSpecialtiesUseCase(sl()));
  sl.registerLazySingleton(() => SearchForDoctorsUseCase(sl())); // الإضافة الجديدة

  // Repositories
  sl.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DoctorRepository>( // الإضافة الجديدة
    () => DoctorRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SpecialtyRemoteDataSource>(
    () => SpecialtyRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<DoctorRemoteDataSource>( // الإضافة الجديدة
    () => DoctorRemoteDataSourceImpl(dio: sl()),
  );


  // ================== Core / External ==================
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

    // الـ Interceptor الخاص بك لإضافة التوكين (تم الحفاظ عليه)
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
  
    // الـ Interceptor الخاص بك لطباعة الـ Logs (تم الحفاظ عليه)
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