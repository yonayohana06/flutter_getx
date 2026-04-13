class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  double get discountedPrice => price - (price * discountPercentage / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    stock: json['stock'] as int? ?? 0,
    brand: json['brand'] as String? ?? '-',
    category: json['category'] as String? ?? '',
    thumbnail: json['thumbnail'] as String? ?? '',
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Wrapper response dari DummyJSON
// { products: [...], total: 194, skip: 0, limit: 10 }
class ProductsResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  bool get hasMore => skip + limit < total;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        products: (json['products'] as List<dynamic>)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        skip: json['skip'] as int,
        limit: json['limit'] as int,
      );
}
