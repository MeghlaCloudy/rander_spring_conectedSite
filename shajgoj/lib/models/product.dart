class Product {
  final int? id;
  final String name;
  final String imageUrl;
  final double price;
  final double discountPrice;
  final String discountText;
  final int? categoryId;
  final String? categoryName;

  Product({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPrice = 0,
    this.discountText = "",
    this.categoryId,
    this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'discountPrice': discountPrice,
      'discountText': discountText,
      'categoryId': categoryId,
      // 'categoryName': categoryName,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      discountText: map['discountText'],
      categoryId: map['categoryId'],
      // categoryName: map['categoryName'] as String?,
    );
  }
  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
}
