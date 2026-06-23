/// Category Model
class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String emoji;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.emoji,
    this.productCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      emoji: json['emoji'] as String? ?? '🛒',
      productCount: json['productCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'emoji': emoji,
      'productCount': productCount,
    };
  }
}
