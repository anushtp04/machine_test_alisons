import 'package:equatable/equatable.dart';
import 'package:machine_test_alisons/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final int itemCount;

  const CartLoaded({required this.items, required this.itemCount});

  @override
  List<Object?> get props => [items, itemCount];
}
