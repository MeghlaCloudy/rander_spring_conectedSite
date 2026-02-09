import 'package:flutter/material.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';
import 'package:shajgoj/core/constanst/app_strings.dart';
import 'package:shajgoj/screens/admin/about_screen.dart';
import 'package:shajgoj/screens/admin/add_edit_category.dart';
import 'package:shajgoj/screens/admin/add_edit_product.dart';
import 'package:shajgoj/screens/cart_screen.dart';
import 'package:shajgoj/screens/category_screen.dart';
import 'package:shajgoj/screens/home_screen.dart';
import 'package:shajgoj/screens/login_screen.dart';
import 'package:shajgoj/screens/products_screen.dart';
import 'package:shajgoj/services/database_helper.dart';


// তোমার স্ক্রিনগুলো import করো (যেগুলো আছে)



class CustomDrawer extends StatelessWidget {
   CustomDrawer({super.key});

  final List<String> categories = [
    'Makeup',
    'Skin',
    'Hair',
    'Personal Care',
    'Mom & Baby',
    'Fragrance',
    'Undergarments',
    'Combo',
    'Jewellery',
    'Clearance Sale',
    'Men',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header (Shajgoj স্টাইলের মতো পিঙ্ক)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
            color: AppColors.primaryPink,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore Beauty',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primaryPink),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
                 Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.shopping_bag, color: AppColors.primaryPink),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductsScreen(selectedCategory: '',)),
              );
            },
          ),


            ListTile(
            leading: Icon(Icons.info, color: AppColors.primaryPink),
            title: const Text('Product'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditProduct()),
              );
            },
          ),



               ListTile(
            leading: Icon(Icons.info, color: AppColors.primaryPink),
            title: const Text('Category'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditCategory()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.category, color: AppColors.primaryPink),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesScreen(),
                ),
              );
            },
          ),


          ListTile(
            leading: Icon(Icons.shopping_cart, color: AppColors.primaryPink),
            title: const Text('Cart'),
            trailing: FutureBuilder<int>(
              future: DatabaseHelper.instance.getCartCount(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return count > 0
                    ? CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            onTap: () {
              Navigator.pop(context); // Drawer বন্ধ
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info, color: AppColors.primaryPink),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.login, color: AppColors.primaryPink),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),




          // ক্যাটাগরি লিস্ট (যদি চাও, এখানে রাখা যায়)
          ExpansionTile(
            leading: Icon(Icons.category, color: AppColors.primaryPink),
            title: const Text('All Categories'),
            children: categories.map((category) {
              return ListTile(
                title: Text(category),
                contentPadding: const EdgeInsets.only(left: 60),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('$category clicked')));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
