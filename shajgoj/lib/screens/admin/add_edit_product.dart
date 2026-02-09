import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';
import '../../models/product.dart';
import '../../services/database_helper.dart';

class AddEditProduct extends StatefulWidget {
  final Product? product;

  const AddEditProduct({super.key, this.product});

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  String imageUrl = '';
  File? selectedImage; // গ্যালারি থেকে সিলেক্ট করা ছবি
  late double price;
  double discountPrice = 0;
  String discountText = "";

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = widget.product?.name ?? '';
    imageUrl = widget.product?.imageUrl ?? '';
    price = widget.product?.price ?? 0;
    discountPrice = widget.product?.discountPrice ?? 0;
    discountText = widget.product?.discountText ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        imageUrl =
            pickedFile.path; // ফাইল পাথ সেভ করো (পরে upload করে URL করতে পারো)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 16),

              // Image Picker + Preview
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('Tap to select image from gallery'),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => price = double.parse(value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: discountPrice.toString(),
                decoration: const InputDecoration(
                  labelText: 'Discount Price (optional)',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    discountPrice = double.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: discountText,
                decoration: const InputDecoration(
                  labelText: 'Discount Text (optional)',
                ),
                onSaved: (value) => discountText = value ?? '',
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newProduct = Product(
                        id: widget.product?.id,
                        name: name,
                        imageUrl: imageUrl, // এখন গ্যালারি পাথ বা URL
                        price: price,
                        discountPrice: discountPrice,
                        discountText: discountText,
                      );

                      try {
                        if (widget.product == null) {
                          await DatabaseHelper.instance.insertProduct(
                            newProduct,
                          );
                        } else {
                          await DatabaseHelper.instance.updateProduct(
                            newProduct,
                          );
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
                        print('Failed:------------------- $e');
                      }
                    }
                  },
                  child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
