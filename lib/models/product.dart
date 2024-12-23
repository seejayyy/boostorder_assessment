import 'package:flutter_projects/models/product_attributes.dart';
import 'package:hive/hive.dart';
import 'package:flutter_projects/models/product_image.dart';
import 'package:flutter_projects/models/product_variation.dart';

part 'product.g.dart';

@HiveType(typeId: 0) // Unique typeId for Product
class Product extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String? catalogVisibility;

  @HiveField(4)
  final String sku;

  @HiveField(5)
  final String? regularPrice;

  @HiveField(6)
  final int stockQuantity;

  @HiveField(7)
  final List<ImageData> images;

  @HiveField(8)
  final List<Attributes> attributes;

  @HiveField(9)
  final List<Variation> variations;

  Product({
    required this.id,
    required this.name,
    required this.status,
    required this.catalogVisibility,
    required this.sku,
    required this.regularPrice,
    required this.stockQuantity,
    required this.images,
    required this.attributes,
    required this.variations,
  });

  // JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    status: json['status'],
    catalogVisibility: json['catalog_visibility'],
    sku: json['sku'],
    regularPrice: json['regular_price'],
    stockQuantity: json['stock_quantity'] ?? 0,
    images: (json['images'] as List<dynamic>)
        .map((e) => ImageData.fromJson(e))
        .toList(),
    attributes: (json['attributes'] as List<dynamic>)
        .map((e) => Attributes.fromJson(e, AttributeType.parent))
        .toList(),
    variations: (json['variations'] as List<dynamic>)
        .map((e) => Variation.fromJson(e))
        .toList(),
  );

  // Product to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'catalog_visibility': catalogVisibility,
    'sku': sku,
    'regular_price': regularPrice,
    'stock_quantity': stockQuantity,
    'images': images.map((e) => e.toJson()).toList(),
    'attributes': attributes.map((e) => e.toJson()).toList(),
    'variations': variations.map((e) => e.toJson()).toList(),
  };

  @override
  String toString(){
    final variationsString = variations.isEmpty
        ? 'null'
        : variations.map((v) => v.toString()).join('\n');

    final imageString = images.isEmpty
        ? 'null'
        : images.map((i) => i.toString()).join('\n');

    return '''
    Product:
      ID: $id
      Name: $name
      SKU: $sku
      Regular Price: $regularPrice
      Images: $imageString
      Variations: $variationsString
    ''';
  }
}

