import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/catalog/catalog_screen.dart';
import 'package:flutter_projects/screens/home/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/product.dart';
import 'models/product_category.dart';
import 'models/product_dimensions.dart';
import 'models/product_image.dart';
import 'models/product_variation.dart';
import 'models/product_inventory.dart';
import 'models/product_response.dart';

void main() async {
  // initialize Hive
  await Hive.initFlutter();

  // load env file
  await dotenv.load(fileName: ".env"); // Load the .env file

  // Register adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(DimensionsAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ImageDataAdapter());
  Hive.registerAdapter(VariationAdapter());
  Hive.registerAdapter(InventoryAdapter());
  Hive.registerAdapter(ProductResponseAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/catalogpage': (context) => const CatalogScreen(),
      },
    );
  }
}
