import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Boostorder E-commerce App'),
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Align items tightly in the center
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/boostorder.jpg',
                height: 256,
                width: 256,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 24), // Add spacing between the image and button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/catalogpage');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  'Catalog',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
      ));
  }
}
