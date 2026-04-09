import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freshmart_app/core/Api_client.dart';
import 'package:freshmart_app/params/product_param.dart';
import 'package:freshmart_app/res/Product_resnponse.dart';

class ProductService extends ApiClient {
  
  Future<ProductResponse> getAllProduct() async {
    try {
      final response = await dio.get('/products');
      return ProductResponse.fromListJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  
  Future<ProductResponse> getProductById(int id) async {
    try {
      final response = await dio.get('/products/$id');
      return ProductResponse.fromObjectJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  
  Future<void> createProduct({required ProductParam param, File? image}) async {
    try {
      final formData = FormData.fromMap({
        ...param.toJson(),
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      await dio.post('/products', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  
  Future<void> updateProduct({
    required int id,
    required ProductParam param,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...param.toJson(),
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      await dio.put('/products/$id', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  
  Future<void> deleteProduct(int id) async {
    try {
      await dio.delete('/products/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  
  Future<ProductResponse> searchProduct(String keyword) async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {'search': keyword},
      );

      return ProductResponse.fromListJson(response.data);
    } on DioException {
      return ProductResponse(
        success: false,
        message: 'Data tidak ditemukan',
        data: [],
      );
    }
  }
}
