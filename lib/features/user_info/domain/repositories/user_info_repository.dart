import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/user_info/domain/entities/user_info_entity.dart';

abstract class UserInfoRepository {
  Future<Either<Failure, UserInfoEntity>> getUserInfo();
}