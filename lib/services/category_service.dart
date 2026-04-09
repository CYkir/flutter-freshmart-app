import 'package:dio/dio.dart';
import 'package:freshmart_app/core/Api_client.dart';

import '../res/category_response.dart';

class CategoryService extends ApiClient {
  Future<CategoryResponse> getAllCategory() async {
    try {
      final response = await dio.get('/kategori');
      return CategoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
