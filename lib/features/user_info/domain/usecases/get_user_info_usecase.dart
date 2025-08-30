import 'package:dartz/dartz.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/user_info/domain/entities/user_info_entity.dart';
import 'package:shifaa/features/user_info/domain/repositories/user_info_repository.dart';

class GetUserInfoUsecase implements UseCase<UserInfoEntity, NoParams> {
  final UserInfoRepository repository;

  GetUserInfoUsecase(this.repository);

  @override
  Future<Either<Failure, UserInfoEntity>> call(NoParams params) async {
    return await repository.getUserInfo();
  }
}