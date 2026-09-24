import 'package:equatable/equatable.dart';
import '../models/user_profile_data.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUpdateRequested extends ProfileEvent {
  final UserProfileData updatedProfile;

  const ProfileUpdateRequested(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}
