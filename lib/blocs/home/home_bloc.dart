import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/services/api_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiService _apiService;

  HomeBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(HomeInitial()) {
    on<LoadHome>(_onLoadHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final homeData = await _apiService.getHome(
        id: event.id,
        token: event.token,
      );
      emit(HomeLoaded(homeData));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
