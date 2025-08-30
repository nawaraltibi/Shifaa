part of 'user_info_cubit.dart';



enum UserInfoStatus { initial, loading, success, error }

class UserInfoState extends Equatable {
  final UserInfoStatus status;
  final UserInfoEntity? userInfo;
  final String? errorMessage;

  const UserInfoState({
    this.status = UserInfoStatus.initial,
    this.userInfo,
    this.errorMessage,
  });

  UserInfoState copyWith({
    UserInfoStatus? status,
    UserInfoEntity? userInfo,
    String? errorMessage,
  }) {
    return UserInfoState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userInfo, errorMessage];
}