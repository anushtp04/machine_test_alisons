import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productSlug;

  const AddToCart(this.productSlug);

  @override
  List<Object> get props => [productSlug];
}

class RemoveFromCart extends CartEvent {
  final String productSlug;

  const RemoveFromCart(this.productSlug);

  @override
  List<Object> get props => [productSlug];
}
