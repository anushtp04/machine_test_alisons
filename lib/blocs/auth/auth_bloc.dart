import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SkipRequested>(_onSkipRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(AppConstants.spKeyId);
      final token = prefs.getString(AppConstants.spKeyToken);
      final skipped = prefs.getBool(AppConstants.spKeySkipped) ?? false;

      if (id != null && token != null) {
        emit(Authenticated(id: id, token: token));
      } else if (skipped) {
        emit(AuthSkipped());
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Validation only — no API call
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError('Please fill in all fields'));
        emit(Unauthenticated());
        return;
      }

      // Store credentials and navigate
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.spKeyId, 'user_local');
      await prefs.setString(AppConstants.spKeyToken, 'local_token');
      await prefs.remove(AppConstants.spKeySkipped);

      emit(Authenticated(id: 'user_local', token: 'local_token'));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSkipRequested(
    SkipRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.spKeySkipped, true);
      // Do NOT store auth key
      await prefs.remove(AppConstants.spKeyId);
      await prefs.remove(AppConstants.spKeyToken);

      emit(AuthSkipped());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.spKeyId);
      await prefs.remove(AppConstants.spKeyToken);
      await prefs.remove(AppConstants.spKeySkipped);
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
