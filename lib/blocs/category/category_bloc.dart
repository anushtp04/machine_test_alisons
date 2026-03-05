import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/models/category_model.dart';
import 'package:machine_test_alisons/services/api_service.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiService _apiService;
  List<CategoryModel>? _cachedCategories;

  CategoryBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  void setCategoriesFromHome(List<CategoryModel> categories) {
    _cachedCategories = categories;
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
        emit(CategoryLoaded(_cachedCategories!));
      } else {
        // Fallback: try to get from home API with empty creds (will use mock)
        final homeData = await _apiService.getHome(id: '', token: '');
        emit(CategoryLoaded(homeData.categories));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
