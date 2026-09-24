import 'package:equatable/equatable.dart';
import '../models/user_profile_data.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileUpdatedSuccess extends ProfileState {
  final UserProfileData profile;

  const ProfileUpdatedSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateFailure extends ProfileState {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
