import 'package:freshmart_app/models/Product_model.dart';

class ProductResponse {
  final bool success;
  final String message;

  
  final List<ProductModel>? data;
  final ProductModel? product;

  ProductResponse({
    required this.success,
    required this.message,
    this.data,
    this.product,
  });

  factory ProductResponse.fromListJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<ProductModel>.from(
              json['data'].map((e) => ProductModel.fromJson(e)),
            )
          : [],
    );
  }

  factory ProductResponse.fromObjectJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      product: json['data'] != null
          ? ProductModel.fromJson(json['data'])
          : null,
    );
  }
}
