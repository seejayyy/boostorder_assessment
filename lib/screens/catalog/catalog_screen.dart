import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/models/product_variation.dart';
import 'package:flutter_projects/screens/cart/cart_screen.dart';
import 'package:flutter_projects/services/product_service.dart';
import 'package:flutter_projects/widgets/product_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final List<CartItem> cartItems = [];

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
        // _productService.saveProduct(_products);
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

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }

  void _handleAddToCart(CartItem item) {
    setState(() {
      cartItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${item.variation.name.toString()} ${item.uom} to cart',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Widget productCards;

    if (_isLoading) {
      productCards =
          Center(child: CircularProgressIndicator()); // Loading state
    } else if (_message != null) {
      productCards = Center(child: Text('Error: $_message')); // Error state
    } else if (_products.isEmpty) {
      productCards = Center(child: Text('No products found')); // Empty state
    } else {

      productCards = ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          if (_products[index].catalogVisibility == "visible" ||
              _products[index].catalogVisibility == "publish") {
            return ProductCard(
              product: _products[index],
              onAddToCart: _handleAddToCart,
            );
          }
          return SizedBox.shrink(); // Empty widget for non-matching items
        },
      );

    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              // Text
              Text(
                'Catalog',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          actions: [
            Text(
              'Boostorder',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(
              width: 8,
            ),
            // Rounded Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.check,
                color: Colors.blue,
                size: 18,
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ), // Kebab Menu Icon
              onSelected: (String value) {
                print('Selected: $value');
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                  PopupMenuItem<String>(
                    value: 'share',
                    child: Text('Share'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                    SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      icon: Stack(
                        children: [
                          SvgPicture.asset('assets/shopping_cart.svg', width: 32, height: 32),
                          if (cartItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cartItems.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: _navigateToCart,
                    ),
                  ],
                ),
              ),
              // Expanded to allow ListView to take remaining space
              Expanded(
                child: productCards,
              ),
            ],
          ),
        ));
  }
}
