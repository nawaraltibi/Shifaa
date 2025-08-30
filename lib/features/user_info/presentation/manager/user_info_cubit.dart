import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/user_info/domain/entities/user_info_entity.dart';
import 'package:shifaa/features/user_info/domain/usecases/get_user_info_usecase.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final GetUserInfoUsecase _getUserInfoUsecase;

  UserInfoCubit(this._getUserInfoUsecase) : super(const UserInfoState());

  Future<void> fetchUserInfo() async {
    emit(state.copyWith(status: UserInfoStatus.loading));
    final result = await _getUserInfoUsecase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(status: UserInfoStatus.error, errorMessage: failure.message)),
      (userInfo) => emit(state.copyWith(status: UserInfoStatus.success, userInfo: userInfo)),
    );
  }
}