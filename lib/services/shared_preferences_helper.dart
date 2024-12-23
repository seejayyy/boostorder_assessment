import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import '../models/product.dart'; // Adjust the import path as necessary

class SharedPreferencesHelper {
  // Save a list of products
  static Future<void> saveProducts(List<Product> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productJsonList = products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('product_list_key', productJsonList); // Save list of JSON strings
  }

  // Load all products
  static Future<List<Product>> loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productJsonList = prefs.getStringList('product_list_key');

    if (productJsonList != null) {
      return productJsonList.map((productJson) => Product.fromJson(jsonDecode(productJson))).toList();
    }
    return []; // Return an empty list if no products are found
  }

  static Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    log('All data cleared from SharedPreferences.');
  }
}
