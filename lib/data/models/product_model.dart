import 'package:equatable/equatable.dart';

class ReviewModel {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  const ReviewModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    rating: json['rating'] as int,
    comment: json['comment'] as String? ?? '',
    date: json['date'] as String? ?? '',
    reviewerName: json['reviewerName'] as String? ?? '',
    reviewerEmail: json['reviewerEmail'] as String? ?? '',
  );
}

class DimensionModel {
  final double width;
  final double height;
  final double depth;

  const DimensionModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory DimensionModel.fromJson(Map<String, dynamic> json) => DimensionModel(
    width: (json['width'] as num?)?.toDouble() ?? 0,
    height: (json['height'] as num?)?.toDouble() ?? 0,
    depth: (json['depth'] as num?)?.toDouble() ?? 0,
  );
}

class ProductModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final String? returnPolicy;
  final int minimumOrderQuantity;
  final double weight;
  final DimensionModel? dimensions;
  final List<ReviewModel> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.sku,
    required this.thumbnail,
    required this.images,
    required this.tags,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.weight,
    this.dimensions,
    required this.reviews,
  });

  double get discountedPrice => price - (price * discountPercentage / 100);

  bool get isInStock => stock > 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    category: json['category'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    stock: json['stock'] as int? ?? 0,
    brand: json['brand'] as String? ?? '',
    sku: json['sku'] as String? ?? '',
    thumbnail: json['thumbnail'] as String? ?? '',
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    tags:
        (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
        [],
    warrantyInformation: json['warrantyInformation'] as String?,
    shippingInformation: json['shippingInformation'] as String?,
    availabilityStatus: json['availabilityStatus'] as String?,
    returnPolicy: json['returnPolicy'] as String?,
    minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 1,
    weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
    dimensions: json['dimensions'] != null
        ? DimensionModel.fromJson(json['dimensions'] as Map<String, dynamic>)
        : null,
    reviews:
        (json['reviews'] as List<dynamic>?)
            ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  @override
  List<Object?> get props => [id, sku];
}

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
