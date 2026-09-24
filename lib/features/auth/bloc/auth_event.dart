import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogInSubmitted extends AuthEvent {
  final String email;
  final String password;

  const AuthLogInSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthSignUpSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class AuthGoogleSignInSubmitted extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthResetToInitial extends AuthEvent {}
