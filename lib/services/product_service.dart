import 'dart:convert';
import 'dart:developer';

import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_response.dart';
import 'package:flutter_projects/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class ProductService {
  /// Fetch data from Boostorder
  /// Calls the GET API endpoint from Boostorder
  /// Use the username and password as basic authentication
  /// Get the data, and parse the data into model
  Future<List<Product>> fetchData() async {
    final String username = AppConstants.apiUsername;
    final String password = AppConstants.apiPassword;
    final url =
        'https://cloud.boostorder.com/bo-mart/api/v1/wp-json/wc/v1/bo/products';
    final queryParameters = {
      'page': '1',
    };
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    // Encode username and password in Base64
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': basicAuth},
      );

      if (response.statusCode == 200) {
        // Decode JSON string
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Parse the JSON string
        List<Product> products = ProductResponse.fromJson(jsonData).products;

        return products;
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get the products saved in the Hive box
  Future<List<Product>> getProducts() async {
    // Open the Hive box
    final box = await Hive.openBox('productsBox');

    // Map each entry to a Product object and convert to List
    final products = box.values.map((item) {
      return Product(
        id: item.id,
        name: item.name,
        dateModified: item.dateModified,
        type: item.type,
        status: item.status,
        sku: item.sku,
        regularPrice: item.regularPrice,
        manageStock: item.manageStock,
        inStock: item.inStock,
        dimensions: item.dimensions,
        categories: item.categories,
        images: item.images,
        variations: item.variations,
      );
    }).toList();

    return products;
  }

  /// Save the products in the Hive box
  Future<void> saveProduct(List<Product> products) async {
    final box = await Hive.openBox<Product>('productsBox');
    for (Product product in products) {
      log(product.toString());
      await box.put(product.id, product);
    }
    log('Products saved successfully!');
  }
}
