import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Set<String> _favoriteSlugs = {};

  FavoriteBloc() : super(FavoriteInitial()) {
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<FavoriteState> emit) {
    if (_favoriteSlugs.contains(event.productSlug)) {
      _favoriteSlugs.remove(event.productSlug);
    } else {
      _favoriteSlugs.add(event.productSlug);
    }
    emit(FavoriteUpdated(Set.from(_favoriteSlugs)));
  }
}
