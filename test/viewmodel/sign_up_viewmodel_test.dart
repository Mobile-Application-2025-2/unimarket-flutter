import 'package:flutter_test/flutter_test.dart';
import 'package:unimarket/ui/sign_up/view_model/sign_up_viewmodel.dart';
import 'package:unimarket/ui/sign_up/widgets/sign_up_state.dart';

void main() {
  group('SignUpViewModel Tests', () {
    late SignUpViewModel viewModel;

    setUp(() {
      viewModel = SignUpViewModel();
    });

    test('initial state should be correct', () {
      expect(viewModel.state.loading, false);
      expect(viewModel.state.error, null);
    });

    test('clearError should clear error message', () {
      viewModel.clearError();
      expect(viewModel.state.error, null);
    });

    test('startLoading should set loading state', () async {
      expect(viewModel.state.loading, false);
      
      // Start loading (this will run async)
      final future = viewModel.startLoading();
      
      // After calling startLoading, loading should be true initially
      expect(viewModel.state.loading, true);
      
      // Wait for it to complete
      await future;
      
      // After completion, loading should be false
      expect(viewModel.state.loading, false);
    });
  });

  group('SignUpState Tests', () {
    test('copyWith should update only specified fields', () {
      const state = SignUpState(loading: false);
      
      final newState = state.copyWith(loading: true);
      
      expect(newState.loading, true);
      expect(newState.error, null);
    });

    test('copyWith with null error should clear error', () {
      const state = SignUpState(loading: false, error: 'Test error');
      
      final newState = state.copyWith(error: null);
      
      expect(newState.error, null);
      expect(newState.loading, false);
    });
  });
}
