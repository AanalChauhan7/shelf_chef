import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());
    try {
      await AuthService.updateUserProfile(event.updatedProfile);
      emit(ProfileUpdatedSuccess(event.updatedProfile));
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }
}
