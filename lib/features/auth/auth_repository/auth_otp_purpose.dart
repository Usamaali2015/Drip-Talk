enum AuthOtpPurpose { signupVerification, forgotPassword }

extension AuthOtpPurposeX on AuthOtpPurpose {
  String get queryValue {
    switch (this) {
      case AuthOtpPurpose.signupVerification:
        return 'signup';
      case AuthOtpPurpose.forgotPassword:
        return 'forgot_password';
    }
  }

  bool get usesForgotPasswordEndpoints => this == AuthOtpPurpose.forgotPassword;
}

AuthOtpPurpose authOtpPurposeFromQuery(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'forgot_password':
      return AuthOtpPurpose.forgotPassword;
    case 'signup':
    default:
      return AuthOtpPurpose.signupVerification;
  }
}
