import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/catalog/catalog_screen.dart';
import 'package:flutter_projects/screens/home/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  // load env file
  await dotenv.load(fileName: ".env"); // Load the .env file

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/catalogpage': (context) => const CatalogScreen()
      },
      theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
    );
  }
}
