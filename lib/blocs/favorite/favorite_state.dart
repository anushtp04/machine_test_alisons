import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteUpdated extends FavoriteState {
  final Set<String> favoriteSlugs;

  const FavoriteUpdated(this.favoriteSlugs);

  @override
  List<Object> get props => [favoriteSlugs];
}
