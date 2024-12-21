import 'package:hive/hive.dart';
import 'package:flutter_projects/models/product_category.dart';
import 'package:flutter_projects/models/product_dimensions.dart';
import 'package:flutter_projects/models/product_image.dart';
import 'package:flutter_projects/models/product_variation.dart';

part 'product.g.dart';

@HiveType(typeId: 0) // Unique typeId for Product
class Product extends HiveObject {
  @HiveField(0)
  final num id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? dateModified;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final String sku;

  @HiveField(6)
  final String? regularPrice;

  @HiveField(7)
  final bool manageStock;

  @HiveField(8)
  final bool inStock;

  @HiveField(9)
  final Dimensions dimensions;

  @HiveField(10)
  final List<Category> categories;

  @HiveField(11)
  final List<ImageData> images;

  @HiveField(12)
  final List<Variation> variations;

  Product({
    required this.id,
    required this.name,
    required this.dateModified,
    required this.type,
    required this.status,
    required this.sku,
    required this.regularPrice,
    required this.manageStock,
    required this.inStock,
    required this.dimensions,
    required this.categories,
    required this.images,
    required this.variations,
  });

  // JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      dateModified: json['date_modified'],
      type: json['type'],
      status: json['status'],
      sku: json['sku'],
      regularPrice: json['regular_price'],
      manageStock: json['manage_stock'],
      inStock: json['in_stock'],
      dimensions: Dimensions.fromJson(json['dimensions']),
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
      images: (json['images'] as List)
          .map((image) => ImageData.fromJson(image))
          .toList(),
      variations: (json['variations'] as List)
          .map((variation) => Variation.fromJson(variation))
          .toList(),
    );
  }

  // Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_modified': dateModified,
      'type': type,
      'status': status,
      'sku': sku,
      'regular_price': regularPrice,
      'manage_stock': manageStock,
      'in_stock': inStock,
      'dimensions': dimensions.toJson(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'images': images.map((image) => image.toJson()).toList(),
      'variations': variations.map((variation) => variation.toJson()).toList(),
    };
  }

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
      Date Modified: $dateModified
      Type: $type
      Status: $status
      SKU: $sku
      In Stock: $inStock
      Manage Stock: $manageStock
      Regular Price: $regularPrice
      Categories: ${categories.map((c) => c.name).join(', ')}
      Dimension: $dimensions
      Images: $imageString
      Variations: $variationsString
    ''';
  }
}
