import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_response.dart';
import 'package:flutter_projects/utils/constants.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late StreamSubscription _connectionSubscription;

  void checkConnectivity(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi)) {
      // Fetch data from Boostorder
      fetchData();
    } else {
      // Retrieve data from Hive box
      List<Product> products = getProducts() as List<Product>;
    }
  }

  @override
  void initState() {
    super.initState();

    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  Future<void> saveProduct(List<Product> products) async {
    final box = await Hive.openBox<Product>('productsBox');
    for (Product product in products) {
      await box.put(product.id, product);
    }
    log('Products saved successfully!');
  }

  // Fetch data from Boostorder
  Future<void> fetchData() async {
    final String username = AppConstants.apiUsername;
    final String password = AppConstants.apiPassword;
    final url = 'https://cloud.boostorder.com/bo-mart/api/v1/wp-json/wc/v1/bo/products';
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

        // save the products to local storage
        saveProduct(products);
      } else {
        log('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<Iterable> getProducts() async {
    // Open the Hive box
    final box = await Hive.openBox('productsBox');

    // Retrieve all data
    final allData = box.values;

    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
