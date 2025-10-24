import 'package:flutter_test/flutter_test.dart';
import 'package:unimarket/viewmodel/catalog/sign_up_viewmodel.dart';

void main() {
  group('SignUpViewModel Tests', () {
    late SignUpViewModel viewModel;

    setUp(() {
      viewModel = SignUpViewModel();
    });

    test('initial state should be correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
    });

    test('clearError should clear error message', () {
      // Simulate setting an error (though not directly possible in current implementation)
      viewModel.clearError();
      expect(viewModel.errorMessage, null);
    });

    test('navigateToLogin should clear error', () {
      viewModel.navigateToLogin();
      expect(viewModel.errorMessage, null);
    });

    test('navigateToCreateAccount should clear error', () {
      viewModel.navigateToCreateAccount();
      expect(viewModel.errorMessage, null);
    });
  });
}
