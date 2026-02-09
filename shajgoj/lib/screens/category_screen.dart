import 'package:flutter/material.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';

import 'package:shajgoj/models/category.dart';
import 'package:shajgoj/services/database_helper.dart';
import '../widgets/custom_drawer.dart';
import 'products_screen.dart'; // প্রোডাক্ট স্ক্রিন (ফিল্টার করার জন্য)

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categoriesFuture = DatabaseHelper.instance.getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // পরে সার্চ ফিচার যোগ করতে পারো
            },
          ),
        ],
      ),
      drawer:  CustomDrawer(),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        // ক্যাটাগরি ক্লিক করলে প্রোডাক্ট স্ক্রিনে ফিল্টার করে যাওয়া
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsScreen(
              selectedCategory: category.name, // ফিল্টারের জন্য পাঠাচ্ছি
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryPinkLight, Colors.white],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category.name),
                size: 60,
                color: AppColors.primaryPink,
              ),
              const SizedBox(height: 16),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ক্যাটাগরি অনুযায়ী আইকন (অপশনাল, সুন্দর করার জন্য)
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'makeup':
        return Icons.face;
      case 'skin care':
        return Icons.spa;
      case 'hair care':
        return Icons.cut;
      case 'personal care':
        return Icons.clean_hands;
      case 'mom & baby':
        return Icons.child_care;
      case 'fragrance':
        return Icons.local_florist;
      default:
        return Icons.category;
    }
  }
}
