import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(AppConstants.spKeyId) ?? 'Guest';
      final skipped = prefs.getBool(AppConstants.spKeySkipped) ?? false;

      emit(
        ProfileLoaded(
          name: skipped ? 'Guest User' : 'User',
          email: skipped ? 'Not logged in' : id,
        ),
      );
    } catch (_) {
      emit(const ProfileLoaded(name: 'Guest', email: ''));
    }
  }
}
