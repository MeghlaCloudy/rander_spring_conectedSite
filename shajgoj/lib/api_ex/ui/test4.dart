import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FilledCarvedCardsPage(),
    );
  }
}

class FilledCarvedCardsPage extends StatelessWidget {
  const FilledCarvedCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Filled Carved Cards"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// 🔹 Third Card (bottom)
            Positioned(
              top: 160, // move below second card
              left: 0,
              right: 0,
              child: cardContainer("Third Card", Colors.orangeAccent),
            ),

            /// 🔹 Second Card (middle)
            Positioned(
              top: 80, // move below first card
              left: 0,
              right: 0,
              child: cardContainer("Second Card", Colors.deepPurpleAccent),
            ),

            /// 🔹 First Card (top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: cardContainer("First Card", Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  /// Build a card that visually fills the carved corners
  Widget cardContainer(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
