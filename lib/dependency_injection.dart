import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shifaa/features/search/data/datasources/specialty_remote_data_source.dart';
import 'package:shifaa/features/search/data/repositories/specialty_repository_impl.dart';
import 'package:shifaa/features/search/domain/repositories/specialty_repository.dart';
import 'package:shifaa/features/search/domain/usecases/search_for_specialties_usecase.dart';
import 'package:shifaa/features/search/presentation/manager/specialty_search_cubit.dart';


final sl = GetIt.instance;


Future<String?> getTokenFromStorage() async {
  // final prefs = await SharedPreferences.getInstance();
  // return prefs.getString('user_token');
  
  return '3|FIu5Ynox94OJLziQJEmDNfTh7If1c0ezSQEyM4r275cff210';
}


Future<void> setupServiceLocator() async {
  // Features - Search
  sl.registerFactory(() => SpecialtySearchCubit(searchForSpecialtiesUseCase: sl()));
  sl.registerLazySingleton(() => SearchForSpecialtiesUseCase(sl()));
  sl.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SpecialtyRemoteDataSource>(
    () => SpecialtyRemoteDataSourceImpl(dio: sl()),
  );

  // Core / External
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
