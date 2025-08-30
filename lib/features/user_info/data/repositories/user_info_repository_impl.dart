import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/user_info/data/datasources/user_info_remote_data_source.dart';
import 'package:shifaa/features/user_info/domain/entities/user_info_entity.dart';
import 'package:shifaa/features/user_info/domain/repositories/user_info_repository.dart';

class UserInfoRepositoryImpl implements UserInfoRepository {
  final UserInfoRemoteDataSource remoteDataSource;

  UserInfoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserInfoEntity>> getUserInfo() async {
    try {
      final userInfoModel = await remoteDataSource.getUserInfo();
      return Right(userInfoModel);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDiorError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}