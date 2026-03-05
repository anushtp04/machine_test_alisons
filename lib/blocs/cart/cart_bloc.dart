import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/models/product_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<Product> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(
      CartLoaded(items: List.from(_cartItems), itemCount: _cartItems.length),
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    // For now, just track the slug — a real app would add the full product
    emit(
      CartLoaded(items: List.from(_cartItems), itemCount: _cartItems.length),
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    _cartItems.removeWhere((p) => p.slug == event.productSlug);
    emit(
      CartLoaded(items: List.from(_cartItems), itemCount: _cartItems.length),
    );
  }
}
