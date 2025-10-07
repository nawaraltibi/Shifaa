import 'package:bloc/bloc.dart';
import 'package:shifaa/core/utils/shared_prefs_helper.dart';
import 'package:shifaa/features/auth/data/models/user_auth_model.dart';
import 'package:shifaa/features/auth/domain/usecases/verify_password_usecase.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final VerifyPasswordUseCase verifyPasswordUseCase;

  PasswordCubit(this.verifyPasswordUseCase) : super(PasswordInitial());

  Future<void> verifyPassword({
    required String phone,
    required int otp,
    required String password,
  }) async {
    emit(PasswordLoading());

    final result = await verifyPasswordUseCase(
      phone: phone,
      otp: otp,
      password: password,
    );

    result.fold((failure) => emit(PasswordFailure(failure.message)), (
      userData,
    ) async {
      final token = userData.token;
      if (token != null) {
        await SharedPrefsHelper.instance.saveToken(token);
      }
      emit(PasswordSuccess(userData));
    });
  }
}
