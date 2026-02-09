import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shajgoj/api_ex/services/api_config.dart';
import 'package:shajgoj/api_ex/services/auth_service.dart';


import '../models/product.dart';

class ProductApiService {
  final AuthService authService = AuthService();

  /// 🔓 GET all products
  Future<List<Product>> getAllProducts() async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/products"),
      headers: await authService.headers(auth: true),
    );

    print("GET -> Status: ${res.statusCode}");
    print("Response: ${res.body}");

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else if (res.statusCode == 401) {
      throw Exception("Unauthorized! Invalid or expired token.");
    } else {
      throw Exception("Failed to load products: ${res.body}");
    }
  }

  /// 🔐 GET product by ID
  Future<Product> getProductById(int id) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/products/$id");

    final res = await http.get(
      uri,
      headers: await authService.headers(auth: true),
    );

    print("GET $uri -> Status: ${res.statusCode}");
    print("Response: ${res.body}");

    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 401) {
      throw Exception("Unauthorized! Invalid token.");
    } else if (res.statusCode == 404) {
      throw Exception("Product not found.");
    } else {
      throw Exception("Error fetching product: ${res.body}");
    }
  }

  /// 🛡 CREATE product
  Future<Product> createProduct(Product product) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/products");

    final res = await http.post(
      uri,
      headers: await authService.headers(auth: true),
      body: jsonEncode(product.toJson()),
    );

    print("POST $uri -> Status: ${res.statusCode}");
    print("Response: ${res.body}");

    if (res.statusCode == 200 || res.statusCode == 201) {
      return Product.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 401) {
      throw Exception("Unauthorized! Cannot create product.");
    } else {
      throw Exception("Create failed: ${res.body}");
    }
  }

  /// 📝 UPDATE product
  Future<Product> updateProduct(int id, Product product) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/products/$id");

    final res = await http.put(
      uri,
      headers: await authService.headers(auth: true),
      body: jsonEncode(product.toJson()),
    );

    print("PUT $uri -> Status: ${res.statusCode}");
    print("Response: ${res.body}");

    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 401) {
      throw Exception("Unauthorized! Cannot update product.");
    } else {
      throw Exception("Update failed: ${res.body}");
    }
  }

  /// ❌ DELETE product
  Future<void> deleteProduct(int id) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/products/$id");

    final res = await http.delete(
      uri,
      headers: await authService.headers(auth: true),
    );

    print("DELETE $uri -> Status: ${res.statusCode}");
    print("Response: ${res.body}");

    if (res.statusCode != 200 && res.statusCode != 204) {
      if (res.statusCode == 401) {
        throw Exception("Unauthorized! Cannot delete product.");
      } else if (res.statusCode == 404) {
        throw Exception("Product not found.");
      } else {
        throw Exception("Delete failed: ${res.body}");
      }
    }
  }
}
