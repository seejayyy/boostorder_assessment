import 'package:flutter_projects/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item.g.dart';


@HiveType(typeId: 6)
class CartItem extends HiveObject {
  @HiveField(0)
  final Product variation;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  String uom;

  @HiveField(3)
  int variationIndex;

  CartItem({
    required this.variation,
    required this.quantity,
    required this.uom,
    required this.variationIndex,
  });
}
