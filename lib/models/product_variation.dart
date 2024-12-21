import 'package:hive/hive.dart';

part 'product_variation.g.dart';

@HiveType(typeId: 4) // Unique typeId for Variation
class Variation extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String sku;

  @HiveField(2)
  final String regularPrice;

  @HiveField(3)
  final bool inStock;

  Variation({
    required this.id,
    required this.sku,
    required this.regularPrice,
    required this.inStock,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      sku: json['sku'],
      regularPrice: json['regular_price'],
      inStock: json['in_stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'regular_price': regularPrice,
      'in_stock': inStock,
    };
  }

  @override
  String toString(){
    return '''
      Variation:
        ID: $id
        SKU: $sku
        Regular Price: $regularPrice
        In Stock: $inStock
    ''';
  }
}
