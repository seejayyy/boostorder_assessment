import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartState {
  static final ValueNotifier<List<CartItem>> cartItems = ValueNotifier([]);

  static void addToCart(CartItem item) {
    cartItems.value = [...cartItems.value, item];
  }

  static void clearCart() {
    cartItems.value = [];
  }
}
