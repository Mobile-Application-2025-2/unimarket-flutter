class CreateAccountState {
  final bool loading;
  final String? errorMessage;
  final String name;
  final String? nameError;
  final String email;
  final String? emailError;
  final String password;
  final String? passwordError;
  final String confirmPassword;
  final String accountType; // 'buyer' | 'deliver' | 'business'
  final bool acceptedPrivacy;

  const CreateAccountState({
    this.loading = false,
    this.errorMessage,
    this.name = '',
    this.nameError,
    this.email = '',
    this.emailError,
    this.password = '',
    this.passwordError,
    this.confirmPassword = '',
    this.accountType = 'buyer',
    this.acceptedPrivacy = false,
  });

  CreateAccountState copyWith({
    bool? loading,
    String? errorMessage,
    String? name,
    String? nameError,
    String? email,
    String? emailError,
    String? password,
    String? passwordError,
    String? confirmPassword,
    String? accountType,
    bool? acceptedPrivacy,
  }) {
    return CreateAccountState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      name: name ?? this.name,
      nameError: nameError,
      email: email ?? this.email,
      emailError: emailError,
      password: password ?? this.password,
      passwordError: passwordError,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      accountType: accountType ?? this.accountType,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }

  bool get passwordsMatch => password.isNotEmpty && password == confirmPassword;
  bool get isValid =>
      !loading &&
      (nameError == null) &&
      (emailError == null) &&
      (passwordError == null) &&
      name.trim().length >= 2 &&
      email.isNotEmpty &&
      password.length >= 6 &&
      passwordsMatch &&
      acceptedPrivacy;
}
