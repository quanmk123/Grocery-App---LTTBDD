/// Product Model
class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;
  final int? discount; // phần trăm giảm giá
  final String description;
  final String categoryId;
  final String categoryName;
  final double rating;
  final int reviewCount;
  final int stock;
  bool isFavorite;

  // Tags để phân loại
  final bool isFlashSale;
  final bool isBestSeller;
  final bool isRecommended;
  final bool isNew;

  // Unit (kg, g, ml, cái, etc.)
  final String unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    this.isFavorite = false,
    this.isFlashSale = false,
    this.isBestSeller = false,
    this.isRecommended = false,
    this.isNew = false,
    this.unit = 'kg',
  });

  bool get isOutOfStock => stock <= 0;
  bool get hasDiscount => discount != null && discount! > 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      discount: json['discount'] as int?,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      stock: json['stock'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isFlashSale: json['isFlashSale'] as bool? ?? false,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      unit: json['unit'] as String? ?? 'kg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'isFavorite': isFavorite,
      'isFlashSale': isFlashSale,
      'isBestSeller': isBestSeller,
      'isRecommended': isRecommended,
      'isNew': isNew,
      'unit': unit,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    double? oldPrice,
    int? discount,
    String? description,
    String? categoryId,
    String? categoryName,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? isFavorite,
    bool? isFlashSale,
    bool? isBestSeller,
    bool? isRecommended,
    bool? isNew,
    String? unit,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isRecommended: isRecommended ?? this.isRecommended,
      isNew: isNew ?? this.isNew,
      unit: unit ?? this.unit,
    );
  }
}
