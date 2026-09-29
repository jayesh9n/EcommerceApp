class Product {
  final String id;
  final String title;
  final String categoryId;
  final double mrp;
  final double sellingPrice;
  final String unitLabel;
  final String imageUrl;
  final int stock;

  const Product({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.mrp,
    required this.sellingPrice,
    required this.unitLabel,
    required this.imageUrl,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      unitLabel: json['unitLabel'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'mrp': mrp,
      'sellingPrice': sellingPrice,
      'unitLabel': unitLabel,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;
  final int subCount;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.subCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      subCount: (json['subCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'subCount': subCount,
    };
  }
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
