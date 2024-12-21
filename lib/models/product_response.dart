import 'package:hive/hive.dart';
import 'product.dart';

part 'product_response.g.dart';

@HiveType(typeId: 6) // Unique typeId for ProductResponse
class ProductResponse extends HiveObject {
  @HiveField(0)
  final List<Product> products;

  ProductResponse({required this.products});

  // Factory method to parse JSON into a ProductResponse object
  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  // Method to convert a ProductResponse object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}