import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavorite extends FavoriteEvent {
  final String productSlug;

  const ToggleFavorite(this.productSlug);

  @override
  List<Object> get props => [productSlug];
}
