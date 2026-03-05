import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<DecrementCartItem>(_onDecrementCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);
  }

  int get _totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoaded(items: List.from(_cartItems), itemCount: _totalItems));
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final index = _cartItems.indexWhere(
      (item) => item.product.slug == event.product.slug,
    );
    if (index >= 0) {
      final currentItem = _cartItems[index];
      _cartItems[index] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
    } else {
      _cartItems.add(CartItem(product: event.product, quantity: 1));
    }
    emit(CartLoaded(items: List.from(_cartItems), itemCount: _totalItems));
  }

  Future<void> _onDecrementCartItem(
    DecrementCartItem event,
    Emitter<CartState> emit,
  ) async {
    final index = _cartItems.indexWhere(
      (item) => item.product.slug == event.product.slug,
    );
    if (index >= 0) {
      final currentItem = _cartItems[index];
      if (currentItem.quantity > 1) {
        _cartItems[index] = currentItem.copyWith(
          quantity: currentItem.quantity - 1,
        );
      } else {
        _cartItems.removeAt(index);
      }
    }
    emit(CartLoaded(items: List.from(_cartItems), itemCount: _totalItems));
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    _cartItems.removeWhere((item) => item.product.slug == event.product.slug);
    emit(CartLoaded(items: List.from(_cartItems), itemCount: _totalItems));
  }
}
