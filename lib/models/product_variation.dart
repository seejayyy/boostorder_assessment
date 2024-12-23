import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_attributes.dart';
import 'package:flutter_projects/models/product_image.dart';
import 'package:flutter_projects/models/product_inventory.dart';

class Variation extends Product{

  final List<Inventory> inventory;

  final String uom;

  final List<ImageData> image;

  Variation({
    required int id,
    required String name,
    required String status,
    required String catalogVisibility,
    required String sku,
    required String? regularPrice,
    required int stockQuantity,
    required List<ImageData> images,
    required List<Attributes> attributes,
    required this.inventory,
    required this.uom,
    required this.image,
  }) :
        super(
        id: id,
        name: name,
        status: status,
        catalogVisibility: catalogVisibility,
        sku: sku,
        regularPrice: regularPrice,
        stockQuantity: stockQuantity,
        images: images,
        attributes: attributes,
        variations: [],
      );

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
    id: json['id'],
    name: json['name'] ?? '',
    status: json['status'] ?? '',
    catalogVisibility: json['catalog_visibility'] ?? '',
    sku: json['sku'] ?? '',
    regularPrice: json['regular_price']?.toString(),
    stockQuantity: json['stock_quantity'] ?? 0,
    images: [],
    attributes: (json['attributes'] as List<dynamic>)
        .map((e) => Attributes.fromJson(e, AttributeType.variation))
        .toList(),
    inventory: (json['inventory'] as List<dynamic>)
        .map((e) => Inventory.fromJson(e))
        .toList(),
    uom: json['uom'],
    image: (json['image'] as List<dynamic>)
        .map((e) => ImageData.fromJson(e))
        .toList()
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'catalog_visibility': catalogVisibility,
    'sku': sku,
    'regular_price': regularPrice,
    'stock_quantity': stockQuantity,
    'images': images.map((e) => e.toJson()).toList(),
    'attributes': attributes.map((e) => e.toJson()).toList(),
    'variations': variations.map((e) => e.toJson()).toList(),
    'inventory': inventory.map((e) => e.toJson()).toList(),
    'uom': uom,
    'image': image.map((e) => e.toJson()).toList(),
  };

  @override
  String toString(){
    return '''
      Variation:
        ID: $id
        SKU: $sku
        Regular Price: $regularPrice
    ''';
  }
}
