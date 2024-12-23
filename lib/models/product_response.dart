import 'product.dart';

class ProductResponse{
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
