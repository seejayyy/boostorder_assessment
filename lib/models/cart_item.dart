import 'package:flutter_projects/models/product.dart';


class CartItem {

  final Product product;

  int quantity;

  String uom;

  int variationIndex;

  CartItem({
    required this.product,
    required this.quantity,
    required this.uom,
    required this.variationIndex,
  });
}
