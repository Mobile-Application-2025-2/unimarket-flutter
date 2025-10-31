import 'dart:io';

class StudentCodeState {
  final bool loading;
  final String? error;
  final String userName;
  final String studentCodeText;
  final File? imageFile; // Local-only preview
  final bool submitted;
  final bool isVerified;

  const StudentCodeState({
    this.loading = false,
    this.error,
    this.userName = '',
    this.studentCodeText = '',
    this.imageFile,
    this.submitted = false,
    this.isVerified = false,
  });

  bool get canSubmit => !loading && studentCodeText.trim().isNotEmpty;

  StudentCodeState copyWith({
    bool? loading,
    String? error,
    String? userName,
    String? studentCodeText,
    File? imageFile,
    bool? submitted,
    bool? isVerified,
  }) {
    return StudentCodeState(
      loading: loading ?? this.loading,
      error: error,
      userName: userName ?? this.userName,
      studentCodeText: studentCodeText ?? this.studentCodeText,
      imageFile: imageFile ?? this.imageFile,
      submitted: submitted ?? this.submitted,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
