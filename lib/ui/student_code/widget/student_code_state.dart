import 'dart:io';

class StudentCodeState {
  final bool loading;
  final String? error;

  final bool hasPermission;
  final File? imageFile;
  final String userName;

  final bool submitted;
  final bool isVerified;

  const StudentCodeState({
    this.loading = false,
    this.error,
    this.hasPermission = false,
    this.imageFile,
    this.userName = '',
    this.submitted = false,
    this.isVerified = false,
  });

  StudentCodeState copyWith({
    bool? loading,
    String? error,
    bool? hasPermission,
    File? imageFile,
    String? userName,
    bool? submitted,
    bool? isVerified,
  }) {
    return StudentCodeState(
      loading: loading ?? this.loading,
      error: error,
      hasPermission: hasPermission ?? this.hasPermission,
      imageFile: imageFile ?? this.imageFile,
      userName: userName ?? this.userName,
      submitted: submitted ?? this.submitted,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  bool get hasPhoto => imageFile != null;
  bool get canSubmit => !loading && hasPhoto;
}
