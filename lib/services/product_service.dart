import 'dart:convert';
import 'dart:developer';

import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_response.dart';
import 'package:flutter_projects/services/shared_preferences_helper.dart';
import 'package:flutter_projects/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductService {
  /// Fetch data from Boostorder
  /// Calls the GET API endpoint from Boostorder
  /// Use the username and password as basic authentication
  /// Get the data, and parse the data into model
  Future<List<Product>> fetchData(int page) async {
    final String username = AppConstants.apiUsername;
    final String password = AppConstants.apiPassword;
    final url =
        'https://cloud.boostorder.com/bo-mart/api/v1/wp-json/wc/v1/bo/products';
    var queryParameters = {
      'page': '$page',
    };
    var uri = Uri.parse(url).replace(queryParameters: queryParameters);
    // Encode username and password in Base64
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': basicAuth },
      );

      if (response.statusCode == 200) {
        // Decode JSON string
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        Map<String, String> responseHeaders = response.headers;

        int numOfPages = int.tryParse(responseHeaders['x-wc-totalpages'] ?? '') ?? 0;

        if (numOfPages - 1 == 0){
          return ProductResponse.fromJson(jsonData).products;
        }
        else {
          List<Product> products = [];

          products.addAll(ProductResponse.fromJson(jsonData).products);

          for (int i = 0; i < numOfPages - 1; i ++){
            queryParameters = {
              'page': '${page + i + 1}'
            };

            uri = Uri.parse(url).replace(queryParameters: queryParameters);

            try {
              final response = await http.get(
                uri,
                headers: {'Authorization': basicAuth},
              );

              if (response.statusCode == 200) {
                // Decode JSON string
                Map<String, dynamic> jsonData = jsonDecode(response.body);

                products.addAll(ProductResponse
                    .fromJson(jsonData)
                    .products);
              }
              else {
                throw Exception(
                    'Failed with status code: ${response.statusCode}');
              }
            }
            catch (e){
              throw Exception('Error: $e');
            }
          }
          return products;
        }
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
    List<Product> products = await SharedPreferencesHelper.loadProducts();

    if (products.isNotEmpty) {
      // Use the loaded products (e.g., display them in a ListView)
      return products;
    }
    return [];

  }

  /// Save the products in the Hive box
  Future<void> saveProduct(List<Product> products) async {
    await SharedPreferencesHelper.saveProducts(products);
    log('Products saved successfully!');
  }
}
