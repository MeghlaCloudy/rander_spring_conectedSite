import 'package:flutter/material.dart';
import 'package:shajgoj/api_ex/models/product.dart';
import 'package:shajgoj/api_ex/services/product_api.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product; // 👈 optional (null = create)

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final api = ProductApiService();

  final nameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final ratingCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  bool active = true;
  bool loading = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    // Prefill fields if editing
    final p = widget.product;
    if (p != null) {
      nameCtrl.text = p.name;
      categoryCtrl.text = p.category;
      priceCtrl.text = p.price.toString();
      descCtrl.text = p.description ?? '';
      stockCtrl.text = p.stock?.toString() ?? '';
      ratingCtrl.text = p.rating?.toString() ?? '';
      imageCtrl.text = p.imageUrl ?? '';
      active = p.active ?? true;
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final product = Product(
        id: widget.product?.id,
        name: nameCtrl.text,
        category: categoryCtrl.text,
        price: double.parse(priceCtrl.text),
        description: descCtrl.text,
        stock: int.parse(stockCtrl.text),
        active: active,
        rating: double.parse(ratingCtrl.text),
        imageUrl: imageCtrl.text,
      );

      if (isEdit) {
        await api.updateProduct(product.id!, product);
      } else {
        await api.createProduct(product);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? "✏️ Product updated" : "✅ Product created"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Product" : "Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(nameCtrl, "Product Name"),
              _input(categoryCtrl, "Category"),
              _input(priceCtrl, "Price", isNumber: true),
              _input(stockCtrl, "Stock", isNumber: true),
              _input(ratingCtrl, "Rating (0–5)", isNumber: true),
              _input(imageCtrl, "Image URL"),
              _input(descCtrl, "Description", maxLines: 3),

              SwitchListTile(
                title: const Text("Active"),
                value: active,
                onChanged: (v) => setState(() => active = v),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEdit ? "UPDATE PRODUCT" : "SAVE PRODUCT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }
}
