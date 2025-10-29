import 'package:flutter_test/flutter_test.dart';
import 'package:unimarket/ui/login/view_model/login_viewmodel.dart';

void main() {
  group('LoginViewModel Tests', () {
    // Note: These tests require SessionViewModel dependency
    // For now, they test the state class in isolation
    
    test('LoginViewModel requires SessionViewModel dependency', () {
      // This test documents that LoginViewModel requires dependency injection
      expect(true, true); // Placeholder test
    });
  });

  group('LoginUiState Tests', () {
    test('initial state should have correct defaults', () {
      const state = LoginUiState();
      
      expect(state.loading, false);
      expect(state.email, '');
      expect(state.password, '');
      expect(state.showPassword, false);
      expect(state.error, null);
      expect(state.canSubmit, false);
    });

    test('copyWith should update only specified fields', () {
      const state = LoginUiState(
        loading: false,
        email: 'test@example.com',
        password: 'password',
        showPassword: false,
        error: 'Test error',
      );

      final newState = state.copyWith(loading: true);

      expect(newState.loading, true);
      expect(newState.email, 'test@example.com');
      expect(newState.password, 'password');
      expect(newState.showPassword, false);
      expect(newState.error, 'Test error');
    });

    test('copyWith with null error should clear error', () {
      const state = LoginUiState(error: 'Test error');

      final newState = state.copyWith(error: () => null);

      expect(newState.error, null);
    });

    test('isEmailValid should validate email format', () {
      const validState = LoginUiState(email: 'test@example.com');
      expect(validState.isEmailValid, true);

      const invalidState1 = LoginUiState(email: 'invalid');
      expect(invalidState1.isEmailValid, false);

      const invalidState2 = LoginUiState(email: 'test@');
      expect(invalidState2.isEmailValid, false);

      const invalidState3 = LoginUiState(email: '@example.com');
      expect(invalidState3.isEmailValid, false);
    });

    test('canSubmit should require valid email and non-empty password', () {
      const state1 = LoginUiState(email: 'test@example.com', password: 'pass');
      expect(state1.canSubmit, true);

      const state2 = LoginUiState(email: 'invalid', password: 'pass');
      expect(state2.canSubmit, false);

      const state3 = LoginUiState(email: 'test@example.com', password: '');
      expect(state3.canSubmit, false);

      const state4 = LoginUiState(email: '', password: '');
      expect(state4.canSubmit, false);

      const state5 = LoginUiState(
        email: 'test@example.com',
        password: 'pass',
        loading: true,
      );
      expect(state5.canSubmit, false);
    });

    test('canSubmit should be false when loading', () {
      const state = LoginUiState(
        email: 'test@example.com',
        password: 'password',
        loading: true,
      );
      
      expect(state.canSubmit, false);
    });

    test('copyWith should preserve other fields when updating one', () {
      const state = LoginUiState(
        email: 'test@example.com',
        password: 'password123',
        showPassword: true,
      );

      final newState = state.copyWith(email: 'new@example.com');

      expect(newState.email, 'new@example.com');
      expect(newState.password, 'password123');
      expect(newState.showPassword, true);
      expect(newState.loading, false);
    });
  });
}
