class ProductModel {
  int? id;
  String name;
  String description;
  double price;
  String? image;
  String category;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
    required this.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      image: map['image'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
    };
  }
}