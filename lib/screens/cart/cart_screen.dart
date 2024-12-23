import 'package:flutter/material.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/widgets/cart_card.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeItemFromCart(CartItem item) {
    setState(() {
      widget.cartItems.remove(item); // Remove item from the cart
    });
  }

  void _clearCart() {
    setState(() {
      widget.cartItems.clear(); // Clear all cart items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text(
              'Cart',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Text(
            'Boostorder',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: _clearCart, // Clear cart
          ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text('No items in the cart'))
          : ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          return CartCard(
            cartItem: widget.cartItems[index],
            onRemove: _removeItemFromCart,
          );
        },
      ),
    );
  }
}
