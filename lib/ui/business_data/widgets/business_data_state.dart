import 'dart:io';

/// State class for Business Data onboarding screen
class BusinessDataState {
  final bool loading;
  final String? error;
  final String userName;
  final String businessId;
  final String address;
  final String category;
  final File? imageFile;
  final bool submitted;

  const BusinessDataState({
    this.loading = false,
    this.error,
    this.userName = '',
    this.businessId = '',
    this.address = '',
    this.category = '',
    this.imageFile,
    this.submitted = false,
  });

  bool get hasPhoto => imageFile != null;

  bool get canSubmit =>
      !loading &&
      businessId.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      category.trim().isNotEmpty;

  BusinessDataState copyWith({
    bool? loading,
    String? error, // pass null to clear
    String? userName,
    String? businessId,
    String? address,
    String? category,
    File? imageFile, // pass null to remove
    bool? submitted,
  }) {
    return BusinessDataState(
      loading: loading ?? this.loading,
      error: error,
      userName: userName ?? this.userName,
      businessId: businessId ?? this.businessId,
      address: address ?? this.address,
      category: category ?? this.category,
      imageFile: imageFile ?? this.imageFile,
      submitted: submitted ?? this.submitted,
    );
  }
}

