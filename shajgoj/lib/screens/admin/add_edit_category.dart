import 'package:flutter/material.dart';
import 'package:shajgoj/core/constanst/app_colors.dart';
import '../../models/category.dart';
import '../../services/database_helper.dart';

class AddEditCategory extends StatefulWidget {
  final Category? category;

  const AddEditCategory({super.key, this.category});

  @override
  State<AddEditCategory> createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.category?.name ?? '';
    _nameController.text = name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category name is required';
                  }
                  return null;
                },
                onSaved: (value) => name = value!.trim(),
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

                      final newCategory = Category(
                        id: widget.category?.id,
                        name: name,
                      );

                      if (widget.category == null) {
                        await DatabaseHelper.instance.insertCategory(
                          newCategory,
                        );
                      } else {
                        await DatabaseHelper.instance.updateCategory(
                          newCategory,
                        );
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.category == null
                        ? 'Add Category'
                        : 'Update Category',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
