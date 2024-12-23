import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_variation.dart';
import 'package:input_quantity/input_quantity.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(CartItem) onAddToCart;

  const ProductCard(
      {super.key, required this.product, required this.onAddToCart});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final Map<String, dynamic> uomProductMap;
  late Product selectedVariation;
  int quantity = 1;
  late String productSku;
  late String productPrice;
  late String productUOM;
  String? selectedUom;
  num? stockQuantity;

  void _addToCart() {
    if (selectedVariation != null && selectedUom != null) {
      widget.onAddToCart(
        CartItem(
          product: widget.product,
          quantity: quantity,
          uom: selectedUom!, // Pass the selected UOM
          variationIndex: uomProductMap[selectedUom!]!, // Pass the index
        ),
      );
    } else {
      log('Error: Variation or UOM is not selected');
    }
  }

  void initialiseProductData() {
    uomProductMap = {
      for (int i = 0; i < widget.product.variations.length; i++)
        widget.product.variations[i].uom: i
    };
    if (uomProductMap.isNotEmpty) {
      selectedUom = uomProductMap.keys.first;
      selectedVariation =
          widget.product.variations[uomProductMap[selectedUom]!];
      productSku = selectedVariation.sku;
      productPrice = double.tryParse(selectedVariation.regularPrice ?? '0.00')
              ?.toStringAsFixed(2) ??
          '0.00';
      stockQuantity =
          (selectedVariation as Variation).inventory.first.stockQuantity;
    } else {
      selectedUom = null;
      selectedVariation = widget.product;
      productSku = widget.product.sku;
      productPrice = double.tryParse(widget.product.regularPrice ?? '0.00')
              ?.toStringAsFixed(2) ??
          '0.00';
      stockQuantity = widget.product.stockQuantity;
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
                        Text(productSku.toString()),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${stockQuantity.toString()} in stock',
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
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
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.grey,
                      );
                    },
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
                IntrinsicWidth(
                  child: DropdownButtonFormField<String>(
                    isDense: true,
                    elevation: 1,
                    value: selectedUom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1), // Border color when focused (clicked)
                      ),
                    ),
                    hint: Text('Select UOM'),
                    items: uomProductMap.keys.map((String uom) {
                      return DropdownMenuItem<String>(
                        value: uom,
                        child: Text(uom),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUom = newValue!;
                        int variationIndex =
                            uomProductMap[selectedUom]!; // Get index from the map
                        selectedVariation =
                            widget.product.variations[variationIndex];
                        productSku = selectedVariation.sku;
                        productPrice = double.tryParse(
                                    selectedVariation.regularPrice ?? '0.00')
                                ?.toStringAsFixed(2) ??
                            '0.00';
                        stockQuantity = (selectedVariation as Variation)
                            .inventory
                            .first
                            .stockQuantity;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8,),
                InputQty.int(
                  decoration: QtyDecorationProps(
                    borderShape: BorderShapeBtn.none,
                    btnColor: Colors.grey,
                  ),
                  qtyFormProps: QtyFormProps(enableTyping: false),
                  maxVal: 100,
                  initVal: quantity,
                  minVal: 1,
                  steps: 1,
                  onQtyChanged: (val) {
                    setState(() {
                      quantity = val;
                    });
                  },
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
