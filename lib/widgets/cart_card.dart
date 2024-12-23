import 'package:flutter/material.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/models/product.dart';

class CartCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(CartItem) onRemove;

  const CartCard({
    super.key,
    required this.cartItem,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (cartItem.variation.images.isNotEmpty) {
      imageUrl = cartItem.variation.images[0].srcSmall;
    } else {
      imageUrl = 'assets/default_image.png';
    }

    String price = double.tryParse(cartItem.variation.variations[cartItem.variationIndex].regularPrice ?? '0.00')
        ?.toStringAsFixed(2) ??
        '0.00';

    return Dismissible(
      key: ValueKey(cartItem.variationIndex), // Assuming cartItem has an id
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) {
        onRemove(cartItem); // Call the onRemove callback when swiped
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
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Image.network(imageUrl), // Assuming product has an image URL
          title: Text(cartItem.variation.name.toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: RM$price'),
              Text('UOM: ${cartItem.uom}'),
            ],
          ),
        ),
      ),
    );
  }
}
