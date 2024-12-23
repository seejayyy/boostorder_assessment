import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_variation.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(CartItem) onAddToCart;

  const ProductCard(
      {Key? key, required this.product, required this.onAddToCart})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final Map<String, dynamic> uomProductMap;
  late Product selectedVariation;
  int quantity = 1;
  late String productSku;
  // late String productName;
  late String productPrice;
  late String productUOM;
  String? selectedUom;

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }


  void _addToCart() {
    if (selectedVariation != null && selectedUom != null) {
      widget.onAddToCart(
        CartItem(
          variation: selectedVariation,
          quantity: quantity,
          uom: selectedUom!, // Pass the selected UOM
          variationIndex: uomProductMap[selectedUom!]!, // Pass the index
        ),
      );
    } else {
      print('Error: Variation or UOM is not selected');
    }
  }


  void initialiseProductData() {
    uomProductMap = {
      for (int i = 0; i < widget.product.variations.length; i++) widget.product.variations[i].uom: i
    };
    if (uomProductMap.isNotEmpty) {
      selectedUom = uomProductMap.keys.first;
      selectedVariation = widget.product.variations[uomProductMap[selectedUom]!];
      productSku = selectedVariation.sku;
      productPrice = double.tryParse(selectedVariation.regularPrice ?? '0.00')
          ?.toStringAsFixed(2) ??
          '0.00';
    } else {
      selectedUom = null;
      selectedVariation = widget.product;
      productSku = widget.product.sku;
      productPrice = double.tryParse(widget.product.regularPrice ?? '0.00')
          ?.toStringAsFixed(2) ??
          '0.00';
    }
  }


  @override
  void initState() {
    super.initState();
    initialiseProductData();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (widget.product.images.isNotEmpty) {
      imageUrl = widget.product.images[0].srcSmall;
    } else {
      imageUrl = 'assets/default_image.png';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                    Text(productSku.toString()),
                    Text(widget.product.name.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('RM ${productPrice.toString()}',
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
                DropdownButton<String>(
                  value: selectedUom,
                  hint: Text('Select UOM'),
                  items: uomProductMap.keys.map((String uom) {
                    return DropdownMenuItem<String>(
                      value: uom,
                      child: Text(uom),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUom = newValue!;
                      int variationIndex = uomProductMap[selectedUom]!; // Get index from the map
                      selectedVariation = widget.product.variations[variationIndex];
                      productSku = selectedVariation.sku;
                      productPrice = double.tryParse(selectedVariation.regularPrice ?? '0.00')
                          ?.toStringAsFixed(2) ??
                          '0.00';
                    });

                    print('Selected UOM: $selectedUom');
                  },
                ),

                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _decreaseQuantity,
                        icon: Icon(Icons.remove),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        onPressed: _increaseQuantity,
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _addToCart,
                  icon: const Icon(
                    Icons.add_circle,
                    size: 36,
                    color: Colors.blue,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
