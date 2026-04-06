import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drip_talk/features/auth/auth_repository/auth_repository.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordBloc(this._authRepository) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event,
      Emitter<ResetPasswordState> emit,
      ) async {
    emit(ResetPasswordLoading());
    try {
      await _authRepository.resetPassword(
        email: event.email,
        resetToken: event.resetToken,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }
}