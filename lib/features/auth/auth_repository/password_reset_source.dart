enum PasswordResetSource { auth, profile }

extension PasswordResetSourceX on PasswordResetSource {
  String get queryValue {
    switch (this) {
      case PasswordResetSource.auth:
        return 'auth';
      case PasswordResetSource.profile:
        return 'profile';
    }
  }
}

PasswordResetSource passwordResetSourceFromQuery(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'profile':
      return PasswordResetSource.profile;
    case 'auth':
    default:
      return PasswordResetSource.auth;
  }
}
