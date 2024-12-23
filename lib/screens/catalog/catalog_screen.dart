import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_projects/models/cart_item.dart';
import 'package:flutter_projects/models/product.dart';
import 'package:flutter_projects/screens/cart/cart_screen.dart';
import 'package:flutter_projects/services/product_service.dart';
import 'package:flutter_projects/services/shared_preferences_helper.dart';
import 'package:flutter_projects/widgets/product_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_projects/state/cart_state.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late StreamSubscription _connectionSubscription;
  final ProductService _productService = ProductService();
  // final controller = ScrollController();
  final List<Product> _products = [];
  String? _message;
  bool _isLoading = true; // Track loading state
  int page = 1;

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
        // Fetch the first page of data
        final firstPageData = await _productService.fetchData(page);
        setState(() {
          _products.addAll(firstPageData); // Add first page data
          _isLoading = false; // Set loading to false after the first fetch
        });
        await SharedPreferencesHelper.clearAllData();
        await _productService.saveProduct(firstPageData);
      } else {
        // Retrieve data from Hive box
        _products.addAll(await _productService.getProducts());
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

    // Listen to cart updates
    CartState.cartItems.addListener(() {
      setState(() {}); // Force rebuild when cartItems change
    });
  }

  /// Dispose the connectivity subscription after app is closed
  @override
  void dispose() {
    _connectionSubscription.cancel();
    CartState.cartItems.removeListener(() {});
    // controller.dispose();
    super.dispose();
  }

  void _navigateToCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: CartState.cartItems.value,),
      ),
    );
    // Ensure rebuild when returning from CartScreen
    setState(() {});
  }


  void _handleAddToCart(CartItem item) {
    setState(() {
      CartState.cartItems.value.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${item.product.name.toString()} ${item.uom} to cart',
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
        // controller: controller,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          if (_products[index].variations.isNotEmpty && _products[index].variations.first.inventory.isNotEmpty) {
            return ProductCard(
              product: _products[index],
              onAddToCart: _handleAddToCart,
            );
          } else {
            return SizedBox.shrink(); // Or show an error widget
          }
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.blue,
          title: Row(
            children: [
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)
              ),
              padding: EdgeInsets.all(6.0),
              child: Text(
                'B',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ), // Kebab Menu Icon
              onSelected: (String value) {
                log('Selected: $value');
              },
              color: Colors.white,
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
        body: Container(
          color: Colors.white,
          child: Padding(
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
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          side: WidgetStateProperty.all(const BorderSide(color: Colors.grey)),
                          leading: const Icon(Icons.search),
                          hintText: 'Search',
                          backgroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      ValueListenableBuilder<List<CartItem>>(
                        valueListenable: CartState.cartItems,
                        builder: (context, cartItems, child) {
                          return IconButton(
                            icon: Stack(
                              children: [
                                SvgPicture.asset('assets/shopping_cart.svg', width: 36, height: 36),
                                if (CartState.cartItems.value.isNotEmpty)
                                  Positioned(
                                    right: 0,
                                    top: -6,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${CartState.cartItems.value.length}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            onPressed: _navigateToCart,
                          );
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
            ),
          ),
        ));
  }
}
