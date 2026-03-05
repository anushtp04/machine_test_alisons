import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/services/api_service.dart';
import 'package:machine_test_alisons/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;

  AuthBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(AppConstants.spKeyId);
      final token = prefs.getString(AppConstants.spKeyToken);

      if (id != null && token != null) {
        emit(Authenticated(id: id, token: token));
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
      final response = await _apiService.login(
        emailPhone: event.email,
        password: event.password,
      );

      if (response['success'] == 1) {
        final id = response['id']?.toString() ?? '';
        final token = response['token']?.toString() ?? '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.spKeyId, id);
        await prefs.setString(AppConstants.spKeyToken, token);

        emit(Authenticated(id: id, token: token));
      } else {
        emit(AuthError(response['message'] ?? 'Login failed'));
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
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
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
