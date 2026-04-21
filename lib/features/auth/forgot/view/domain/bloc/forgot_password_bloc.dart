import 'package:drip_talk/core/services/api/api_error_resolver.dart';
import 'package:drip_talk/core/utils/app_utils/app_localization_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_event.dart';
import 'package:drip_talk/features/auth/forgot/view/domain/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordSubmitted, ForgotPasswordState> {
  final AuthRepository _repository;

  ForgotPasswordBloc(this._repository) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await _repository.sendForgotPasswordOtp(event.email);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(
          ForgotPasswordError(
            resolveApiErrorMessage(
              e,
              fallback: localizedString(
                fallback: 'Unable to send OTP',
                select: (l10n) => l10n.forgotPasswordOtpSendFailed,
              ),
            ),
          ),
        );
      }
    });
  }
}
