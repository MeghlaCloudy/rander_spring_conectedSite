

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shajgoj.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, fileName);

    return await openDatabase(
      path,
      version: 2, // ← ভার্সন বাড়ানো হয়েছে (নতুন টেবিলের জন্য)
      onCreate: _createDB,
      onUpgrade: _onUpgrade, // নতুন টেবিল যোগ করার জন্য
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        price REAL NOT NULL,
        discountPrice REAL,
        discountText TEXT,
        categoryId INTEGER,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE SET NULL
      )
    ''');

    // Cart table
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        quantity INTEGER DEFAULT 1,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // Orders table (নতুন যোগ করা)
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        delivery_type TEXT,
        payment_method TEXT,
        note TEXT,
        address TEXT,
        area TEXT,
        city TEXT,
        sub_total REAL NOT NULL,
        delivery_fee REAL NOT NULL,
        total REAL NOT NULL,
        status TEXT DEFAULT 'PROCESSING',
        order_date TEXT NOT NULL,
        order_time TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Order Items table (একটা অর্ডারে একাধিক প্রোডাক্ট)
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        image_url TEXT,
        price REAL NOT NULL,
        qty INTEGER NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
      )
    ''');

    // Default categories (যদি চাও)
    await db.insert('categories', {'name': 'Makeup'});
    await db.insert('categories', {'name': 'Skin Care'});
    await db.insert('categories', {'name': 'Hair Care'});
    await db.insert('categories', {'name': 'Personal Care'});
    await db.insert('categories', {'name': 'Mom & Baby'});
    await db.insert('categories', {'name': 'Fragrance'});
  }

  // নতুন ভার্সনের জন্য আপগ্রেড (যদি আগের ডাটাবেস থাকে)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // orders table যোগ করো
      await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_number TEXT NOT NULL,
          customer_name TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT,
          delivery_type TEXT,
          payment_method TEXT,
          note TEXT,
          address TEXT,
          area TEXT,
          city TEXT,
          sub_total REAL NOT NULL,
          delivery_fee REAL NOT NULL,
          total REAL NOT NULL,
          status TEXT DEFAULT 'PROCESSING',
          order_date TEXT NOT NULL,
          order_time TEXT NOT NULL,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // order_items table যোগ করো
      await db.execute('''
        CREATE TABLE order_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          image_url TEXT,
          price REAL NOT NULL,
          qty INTEGER NOT NULL,
          total REAL NOT NULL,
          FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // ===================== Category CRUD =====================
  // (আগের কোড একই রাখা হয়েছে)

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    await db.update(
      'products',
      {'categoryId': null},
      where: 'categoryId = ?',
      whereArgs: [id],
    );
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ===================== Product CRUD =====================
  // (আগের কোড একই রাখা হয়েছে)

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // ===================== Cart CRUD =====================
  // (আগের কোড একই রাখা হয়েছে)

  Future<int> addToCart(int productId, {int quantity = 1}) async {
    final db = await database;

    final existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      return await db.update(
        'cart',
        {'quantity': currentQty + quantity},
        where: 'productId = ?',
        whereArgs: [productId],
      );
    } else {
      return await db.insert('cart', {
        'productId': productId,
        'quantity': quantity,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT p.*, c.id as cartId, c.quantity 
      FROM cart c 
      JOIN products p ON c.productId = p.id
    ''');
  }

  Future<int> removeFromCart(int cartId) async {
    final db = await database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [cartId]);
  }

  Future<int> getCartCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(quantity) as count FROM cart');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> updateCartQuantity(int cartId, int newQty) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': newQty},
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }

  // ===================== Orders =====================

  // নতুন অর্ডার ইনসার্ট (Checkout থেকে কল করবে)
 Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  Future<void> insertOrderItems(int orderId, Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('order_items', {...item, 'order_id': orderId});
  }

  // সব অর্ডার লোড করা (অ্যাডমিন ড্যাশবোর্ডে)
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return await db.query('orders', orderBy: 'id DESC');
  }

  // ইউজার লগইন চেক (যদি পরে লগইন যোগ করো)
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
