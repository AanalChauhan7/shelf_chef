import 'package:equatable/equatable.dart';
import '../../dashboard/models/user_profile_data.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedUpSuccess extends AuthState {
  final String email;

  const AuthSignedUpSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthAuthenticated extends AuthState {
  final UserProfileData userProfile;

  const AuthAuthenticated(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
