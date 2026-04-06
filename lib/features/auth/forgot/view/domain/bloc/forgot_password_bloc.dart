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
        emit(ForgotPasswordError(e.toString()));
      }
    });
  }
}
