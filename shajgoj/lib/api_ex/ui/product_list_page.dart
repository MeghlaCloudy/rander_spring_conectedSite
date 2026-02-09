
import 'package:flutter/material.dart';
import 'package:shajgoj/api_ex/models/product.dart' show Product;
import 'package:shajgoj/api_ex/services/auth_service.dart';
import 'package:shajgoj/api_ex/services/product_api.dart';
import 'package:shajgoj/api_ex/ui/login_page.dart';
import 'package:shajgoj/api_ex/ui/product_form_page.dart';



class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with WidgetsBindingObserver {
  final api = ProductApiService();
  final auth = AuthService();

  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshProducts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Refresh when app comes back to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProducts();
    }
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = api.getAllProducts();
    });
  }

  Future<void> _logout() async {
    await auth.logout();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _addProduct() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormPage()),
    );

    if (created == true) _refreshProducts();
  }



  

  Future<void> _editProduct(Product product) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductFormPage(product: product)),
    );

    if (updated == true) _refreshProducts();
  }

  Future<void> _deleteProduct(Product product) async {
    await api.deleteProduct(product.id!);
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProduct,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshProducts(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final p = products[i];

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      p.imageUrl ?? '',
                      width: 50,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image),
                    ),
                    title: Text(p.name),
                    subtitle: Text("${p.category} • \$${p.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduct(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(p),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
