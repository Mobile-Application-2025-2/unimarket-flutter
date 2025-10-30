class SignUpState {
  final bool loading;
  final String? error;

  const SignUpState({
    this.loading = false,
    this.error,
  });

  SignUpState copyWith({
    bool? loading,
    String? error,
  }) {
    return SignUpState(
      loading: loading ?? this.loading,
      error: error,
    );
  }

  bool get canTapSignUp => !loading;
  bool get canTapLogin  => !loading;
}
