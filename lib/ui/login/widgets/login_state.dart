class LoginState {
  final bool loading;
  final String email;
  final String password;
  final bool showPassword;
  final String? error;
  final bool rememberMe;

  const LoginState({
    this.loading = false,
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.error,
    this.rememberMe = false,
  });

  LoginState copyWith({
    bool? loading,
    String? email,
    String? password,
    bool? showPassword,
    String? error,
    bool? rememberMe,
  }) {
    return LoginState(
      loading: loading ?? this.loading,
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      error: error,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  bool get isEmailValid => RegExp(r'^\S+@\S+\.\S+$').hasMatch(email);
  bool get isPasswordValid => password.isNotEmpty;
  bool get canSubmit => !loading && isEmailValid && isPasswordValid;
}
