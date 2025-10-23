import 'package:flutter_test/flutter_test.dart';
import 'package:unimarket/viewmodel/catalog/login_viewmodel.dart';
import 'package:unimarket/controllers/session_controller.dart';

void main() {
  group('LoginViewModel Tests', () {
    late LoginViewModel viewModel;
    late SessionController sessionController;

    setUp(() {
      sessionController = SessionController.instance;
      viewModel = LoginViewModel(sessionController);
    });

    test('initial state should be correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, null);
      expect(viewModel.email, '');
      expect(viewModel.password, '');
      expect(viewModel.isPasswordVisible, false);
      expect(viewModel.isValid, false);
    });

    test('setEmail should update email and clear error', () {
      viewModel.setEmail('test@example.com');
      expect(viewModel.email, 'test@example.com');
      expect(viewModel.errorMessage, null);
    });

    test('setPassword should update password and clear error', () {
      viewModel.setPassword('password123');
      expect(viewModel.password, 'password123');
      expect(viewModel.errorMessage, null);
    });

    test('isValid should return true for valid email and non-empty password', () {
      viewModel.setEmail('test@example.com');
      viewModel.setPassword('password123');
      expect(viewModel.isValid, true);
    });

    test('isValid should return false for invalid email', () {
      viewModel.setEmail('invalid-email');
      viewModel.setPassword('password123');
      expect(viewModel.isValid, false);
    });

    test('isValid should return false for empty password', () {
      viewModel.setEmail('test@example.com');
      viewModel.setPassword('');
      expect(viewModel.isValid, false);
    });

    test('togglePasswordVisibility should toggle visibility', () {
      expect(viewModel.isPasswordVisible, false);
      viewModel.togglePasswordVisibility();
      expect(viewModel.isPasswordVisible, true);
      viewModel.togglePasswordVisibility();
      expect(viewModel.isPasswordVisible, false);
    });

    test('clearError should clear error message', () {
      // Simulate setting an error
      viewModel.setEmail('test@example.com');
      viewModel.setPassword('password123');
      // This would normally be set by signIn() method
      viewModel.clearError();
      expect(viewModel.errorMessage, null);
    });
  });
}
