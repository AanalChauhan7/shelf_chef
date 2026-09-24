import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLogInSubmitted>(_onLogInSubmitted);
    on<AuthSignUpSubmitted>(_onSignUpSubmitted);
    on<AuthGoogleSignInSubmitted>(_onGoogleSignInSubmitted);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthResetToInitial>(_onResetToInitial);
  }

  Future<void> _onLogInSubmitted(
    AuthLogInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final profile = await AuthService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(profile));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapAuthCodeToMessage(e.code)));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignUpSubmitted(
    AuthSignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await AuthService.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      emit(AuthSignedUpSuccess(event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapAuthCodeToMessage(e.code)));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGoogleSignInSubmitted(
    AuthGoogleSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final profile = await AuthService.signInWithGoogle();
      emit(AuthAuthenticated(profile));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapAuthCodeToMessage(e.code)));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await AuthService.signOut();
    emit(AuthUnauthenticated());
  }

  void _onResetToInitial(AuthResetToInitial event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  String _mapAuthCodeToMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up first!';
      case 'invalid-credential':
        return 'Invalid credentials. If you are a new user, please sign up first!';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please log in!';
      case 'invalid-email':
        return 'The email address format is invalid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'Authentication failed. If you don\'t have an account, please sign up first!';
    }
  }
}
