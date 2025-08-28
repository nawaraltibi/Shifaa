import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shifaa/core/api/api_interceptor.dart';

import 'package:shifaa/core/api/dio_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_appointment/doctor_details/doctor_appointment_remote_data_source.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_appointment/doctor_details/doctor_appointment_remote_data_source_impl.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_appointment_repo/doctor_appointment_repo.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_appointment_repo/doctor_appointment_repo_impl.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_schedule_repo/doctor_schedule_repo_impl.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/book_appointment_use_case.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shifaa/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:shifaa/features/auth/data/repos/auth_repo_impl.dart';
import 'package:shifaa/features/auth/domain/repos/auth_repo.dart';
import 'package:shifaa/features/auth/domain/usecases/register_patient_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_otp_usecase.dart';

import 'package:shifaa/features/book_appointments/data/data_sources/doctor_details/doctor_remote_data_soucre.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_details/doctor_remote_data_soucre_impl.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_details_repo/doctor_repo.dart';
import 'package:shifaa/features/book_appointments/domain/repos/doctor_details_repo/doctor_repo_impl.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_details_use_case.dart';

// ✅ Doctor Schedule Imports
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_schedule/doctor_schedule_remote_data_source_impl.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/get_doctor_schedule_use_case.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_password_usecase.dart';
import 'package:shifaa/features/book_appointments/domain/usecases/reschedule_appointment_use_case.dart';

// Chat Feature Imports
import 'package:shifaa/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:shifaa/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:shifaa/features/chat/domain/repositories/chat_repo.dart';
import 'package:shifaa/features/chat/domain/usecases/create_chat_use_case.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_chats_cubit/get_chats_cubit.dart';
import 'package:shifaa/features/chat/presentation/cubits/get_messages_cubit/get_messages_cubit.dart';
import 'package:shifaa/features/chat/presentation/cubits/mute_chat_cubit/chat_mute_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Dio setup
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.interceptors.add(ApiInterceptor()); // ✅ أضف هذه السطر
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
  getIt.registerLazySingleton(
    () => VerifyPasswordUseCase(getIt<AuthRepository>()),
  );

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
  // ✅ Appointment Feature
  getIt.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(getIt<DioConsumer>()),
  );

  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(getIt<AppointmentRemoteDataSource>()),
  );

  getIt.registerLazySingleton(
    () => BookAppointmentUseCase(getIt<AppointmentRepository>()),
  );

  // ✅ Chat Feature
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => CreateChat(getIt<ChatRepository>()));

  getIt.registerFactory(() => GetMessagesCubit(getIt<ChatRepository>()));

  getIt.registerFactory(() => GetChatsCubit(getIt<ChatRepository>()));
  getIt.registerFactory(() => ChatMuteCubit(getIt<ChatRepository>()));
  getIt.registerLazySingleton(
    () => RescheduleAppointmentUseCase(getIt<AppointmentRepository>()),
  );
  getIt.registerLazySingleton(
    () => CancelAppointmentUseCase(getIt<AppointmentRepository>()),
  );
}
