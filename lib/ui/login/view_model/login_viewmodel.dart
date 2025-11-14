import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/services/firebase_auth_service_adapter.dart';
import '../widgets/login_state.dart';
import 'package:unimarket/utils/result.dart';
import 'package:unimarket/data/daos/student_code_dao.dart';
import 'package:unimarket/data/daos/business_data_dao.dart';

enum LoginError {
  emailNotVerified,
  invalidCredentials,
  unknown,
}

enum LoginRoute {
  studentCode,
  businessData,
  homeBuyer,
}

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth;
  final StudentCodeDao _studentCodeDao;
  final BusinessDataDao _businessDataDao;

  LoginViewModel(this._auth, this._studentCodeDao, this._businessDataDao);

  LoginState _state = const LoginState();

  LoginState get state => _state;

  void _set(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  void setEmail(String value) {
    _set(_state.copyWith(email: value, error: null));
  }

  void setPassword(String value) {
    _set(_state.copyWith(password: value, error: null));
  }

  void togglePasswordVisibility() {
    _set(_state.copyWith(showPassword: !_state.showPassword));
  }

  void clearError() {
    _set(_state.copyWith(error: null));
  }

  /// Clear email and password fields
  void clearFields() {
    _set(_state.copyWith(email: '', password: ''));
  }

  /// Sign in with email and password
  /// Returns true if login was successful, false otherwise
  Future<bool> signIn() async {
    // Guard: check if inputs are valid
    if (!_state.canSubmit) {
      _set(_state.copyWith(error: 'Please fill in all fields correctly'));
      return false;
    }

    _set(_state.copyWith(loading: true, error: null));

    try {
      final user = await _auth.signInWithEmailPassword(
        email: _state.email.trim(),
        password: _state.password,
      );

      // Check if user exists
      if (user == null) {
        _set(_state.copyWith(loading: false, error: 'Login failed'));
        return false;
      }

      // Check if email is verified
      if (!user.emailVerified) {
        _set(_state.copyWith(
          loading: false,
          error: 'Please verify your email before logging in. Check your inbox.',
        ));
        // Sign out the user since email is not verified
        await _auth.signOut();
        return false;
      }

      // Success
      _set(_state.copyWith(loading: false));
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      _set(_state.copyWith(loading: false, error: errorMessage));
      return false;
    } catch (error) {
      _set(_state.copyWith(loading: false, error: 'An unexpected error occurred'));
      return false;
    }
  }

  /// New login flow that returns the route to navigate to after login
  Future<Result<LoginRoute>> login(String email, String password) async {
    try {
      _set(_state.copyWith(loading: true, error: null));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Reload to ensure fresh verification state
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _set(_state.copyWith(loading: false, error: 'Authentication failed'));
        return Result.error(Exception('auth/unknown'));
      }
      if (!user.emailVerified) {
        // Block unverified users
        await FirebaseAuth.instance.signOut();
        _set(_state.copyWith(loading: false, error: 'Please verify your email before logging in.'));
        return Result.error(Exception('auth/email-not-verified'));
      }

      // Email verified → fetch account type
      final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = snap.data() ?? {};
      final accountType = (data['accountType']?.toString()) ?? 'buyer';


      // For business users → check if they already submitted business data
      if (accountType == 'business') {
        final hasBusinessData = await _businessDataDao.hasSubmission(user.uid);
        _set(_state.copyWith(loading: false));
        
        if (hasBusinessData) {
          // Already submitted → go to home
          return Result.ok(LoginRoute.homeBuyer);
        } else {
          // Not submitted yet → go to business data screen
          return Result.ok(LoginRoute.businessData);
        }
      }

      // For buyers → check if they already submitted student code
      final submissionResult = await _studentCodeDao.hasSubmission(user.uid);

      _set(_state.copyWith(loading: false));

      if (submissionResult is Ok<bool> && submissionResult.value == true) {
        // Already submitted → go to home
        return Result.ok(LoginRoute.homeBuyer);
      } else {
        // Not submitted yet → go to student code screen
        return Result.ok(LoginRoute.studentCode);
      }
    } on FirebaseAuthException catch (e) {
      _set(_state.copyWith(loading: false, error: _mapFirebaseAuthError(e)));
      return Result.error(e);
    } catch (e) {
      _set(_state.copyWith(loading: false, error: 'Login failed. Please try again'));
      return Result.error(Exception(e.toString()));
    }
  }

  /// Optional: resend verification email when login blocked by unverified email
  Future<Result<void>> resendVerification(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Result.error(Exception('auth/unknown'));
      }
      await user.sendEmailVerification();
      await FirebaseAuth.instance.signOut();
      return Result.ok(null);
    } catch (e) {
      return Result.error(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> resetPassword() async {
    if (_state.email.trim().isEmpty) {
      _set(_state.copyWith(error: 'Please enter your email address'));
      return;
    }

    if (!_state.isEmailValid) {
      _set(_state.copyWith(error: 'Please enter a valid email address'));
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _state.email.trim());
      _set(_state.copyWith(error: null));
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      _set(_state.copyWith(error: errorMessage));
    } catch (error) {
      _set(_state.copyWith(error: 'An unexpected error occurred'));
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Login failed. Please try again';
    }
  }
}
