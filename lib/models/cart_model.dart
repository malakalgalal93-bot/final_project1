class CartModel {
  int? id;
  int userId;
  int productId;
  int quantity;

  String name;
  String description;
  double price;
  String? image;
  String category;

  CartModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.category,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      userId: map['userId'],
      productId: map['productId'],
      quantity: map['quantity'],
      name: map['name'],
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      image: map['image'],
      category: map['category'],
    );
  }
}