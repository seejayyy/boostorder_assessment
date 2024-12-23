import 'package:flutter/material.dart';
import 'package:flutter_projects/state/cart_state.dart';
import 'package:flutter_projects/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void _clearCart() {
    setState(() {
      CartState.clearCart(); // Clear all cart items
    });
  }

  // Calculate the total price of all items in the cart
  double _calculateTotalPrice() {
    double total = 0.0;
    for (var item in CartState.cartItems.value) {
      String price = '0.00'; // Default price
      if (item.variationIndex >= 0 &&
          item.variationIndex < item.product.variations.length) {
        price = double.tryParse(item.product.variations[item.variationIndex].regularPrice ?? '0.00')
            ?.toStringAsFixed(2) ?? '0.00';
      }
      double totalPrice = double.tryParse(price)! * item.quantity ?? 0.0;
      total += totalPrice; // Add the item's total price to the total
    }
    return total;
  }

  Dismissible buildCard(CartItem cartItem, int index){
    String imageUrl = 'assets/default_image.png'; // Default image URL
    if (cartItem.product != null) {
      if (cartItem.product.images != null && cartItem.product.images.isNotEmpty) {
        imageUrl = cartItem.product.images[0].srcSmall;
      }
    }

    String price = '0.00'; // Default price
    if (cartItem.variationIndex >= 0 &&
        cartItem.variationIndex < cartItem.product.variations.length) {
      price = double.tryParse(cartItem.product.variations[cartItem.variationIndex].regularPrice ?? '0.00')
          ?.toStringAsFixed(2) ?? '0.00';
    }

    double productTotalPrice = 0.00;
    productTotalPrice = double.tryParse(price)! * cartItem.quantity ?? 0.00; // Convert price to double

    return Dismissible(
      key: ValueKey(cartItem.product.sku), // Use a unique key based on cartItem.sku or another unique value
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) {
        setState(() {
          CartState.cartItems.value.removeAt(index);
        }); // Remove item from the cart when dismissed
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: Card(
        color: Colors.white,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${index + 1}. ',
                          style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${cartItem.product.variations[cartItem.variationIndex].sku.toString()}')
                        ],
                      ),
                      Text(cartItem.product.name.toString(),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('RM ${price.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageUrl.startsWith('http')
                        ? Image(
                      image: ResizeImage(
                        NetworkImage(imageUrl),
                        height: 64,
                        width: 64,
                      ),
                    )
                        : Image.asset(
                      imageUrl,
                      height: 64,
                      width: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.only(left: 8), // Optional padding inside the container
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.blue,
                              width: 3.2,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Order'),
                            Text('${cartItem.quantity} ${cartItem.uom} >',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 8), // Optional padding inside the container
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.orange,
                            width: 3.2,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total'),
                          Text('RM ${productTotalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice(); // Get the total price

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
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
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)
            ),
            padding: EdgeInsets.all(6.0),
            child: Text(
              'B',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'clear_cart') {
                _clearCart(); // Call clear cart function
              }
            },
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'clear_cart',
                  child: Text('Clear Cart'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CartState.cartItems.value.isEmpty
              ? Center(child: Text('No items in cart'))
              : Column(
            children: [
              // List of Cart Cards
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: CartState.cartItems.value.length,
                    itemBuilder: (context, index) {
                      return buildCard(
                        CartState.cartItems.value[index],
                        index
                      );
                    },

                            ),
                ),
              // Total Price Row at the Bottom
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'RM ${totalPrice.toStringAsFixed(2)}', // Show the total price
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


