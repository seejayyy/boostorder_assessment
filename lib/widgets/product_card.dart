import 'package:flutter/material.dart';
import 'package:flutter_projects/models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 1;

  void increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void decreaseQuantity() {
    setState(() {
      _quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (widget.product.images != null && widget.product.images.isNotEmpty) {
      imageUrl = widget.product.images[0].srcSmall;
    } else {
      imageUrl =
          'https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg';
    }

    double price = 0.00;

    if (widget.product.regularPrice != null &&
        widget.product.regularPrice!.isNotEmpty) {
      price = double.tryParse(widget.product.regularPrice!) ?? 0.00;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: .5,
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
                    Text(widget.product.sku),
                    Text(widget.product.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('RM ${price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                      image: ResizeImage(NetworkImage(imageUrl),
                          height: 64, width: 64)),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(widget.product.regularPrice.toString()),
            )
          ],
        ),
      ),
    );
  }
}
