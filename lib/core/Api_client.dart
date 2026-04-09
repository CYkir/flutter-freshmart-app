import 'package:dio/dio.dart';

abstract class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2/freshmart/api',
        // baseUrl: 'http://192.168.18.48/freshmart/api',
        headers: {'Accept': 'application/json'},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Dio get dio => _dio;
}
