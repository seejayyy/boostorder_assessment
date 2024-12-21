import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/services/product_service.dart';
import 'package:flutter_projects/widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late StreamSubscription _connectionSubscription;
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  String? _message;
  bool _isLoading = true; // Track loading state

  /// This method is to check if the app has wifi/mobile data connection
  /// If it has connection,
  ///   it will fetch data from Boostorder
  ///   Parse the data and save in Hive box
  /// Else,
  ///   it will get the data from the Hive box
  void checkConnectivity(List<ConnectivityResult> results) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        // Fetch data from Boostorder
        _products = await _productService.fetchData();
        // Save the data in Hive box
        _productService.saveProduct(_products);
      } else {
        // Retrieve data from Hive box
        _products = await _productService.getProducts();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Initialise the connectivity subscription
  @override
  void initState() {
    super.initState();

    _connectionSubscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  /// Dispose the connectivity subscription after app is closed
  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget productCards;

    if (_isLoading) {
      productCards = Center(child: CircularProgressIndicator()); // Loading state
    } else if (_message != null) {
      productCards = Center(child: Text('Error: $_message')); // Error state
    } else if (_products.isEmpty) {
      productCards = Center(child: Text('No products found')); // Empty state
    } else {
      productCards = ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: _products[index]); // Product list
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Categories Name'),
          actions: [

          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      elevation: WidgetStateProperty.all(0.5),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0))),
                      leading: const Icon(Icons.search),
                      hintText: 'Search',
                    ),
                  ),
                  // Icon next to SearchBar
                  IconButton(
                    icon: Icon(Icons.shopping_cart, size: 28),
                    onPressed: () {
                      print('Filter button pressed');
                    },
                  ),
                ],
              ),
            ),
            // Expanded to allow ListView to take remaining space
            Expanded(
              child: productCards,
            ),
          ],
        ));
  }
}
