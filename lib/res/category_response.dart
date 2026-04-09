import 'package:freshmart_app/models/Kategori_model.dart';

class CategoryResponse {
  final bool status;
  final String message;
  final List<KategoriModel> data;

  CategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final List<KategoriModel> listData = rawData is List
        ? rawData.map((e) => KategoriModel.fromJson(e)).toList()
        : [];

    return CategoryResponse(
      status: json['status'] ?? true,
      message: json['message'] ?? '',
      data: listData,
    );
  }
}
