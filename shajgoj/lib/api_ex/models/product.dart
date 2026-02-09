class Product {
  final int? id;
  final String name;
  final String category;
  final double price;
  final String? description;
  final int? stock;
  final bool? active;
  final double? rating;
  final String? imageUrl;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    this.description,
    this.stock,
    this.active,
    this.rating,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    price: (json['price'] as num).toDouble(),
    description: json['description'],
    stock: json['stock'],
    active: json['active'],
    rating: (json['rating'] != null
        ? (json['rating'] as num).toDouble()
        : null),
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    "name": name,
    "category": category,
    "price": price,
    if (description != null) "description": description,
    if (stock != null) "stock": stock,
    if (active != null) "active": active,
    if (rating != null) "rating": rating,
    if (imageUrl != null) "imageUrl": imageUrl,
  };
}
