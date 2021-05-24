import 'package:desafio_framework/app/shared/dio/custom_dio.dart';


class ClientHttp {
  final _dio = CustomDio.instance;

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? queryParameters,}) async {
    final response = await _dio.get<Map<String, dynamic>>(url, queryParameters: queryParameters);
    return Map<String, dynamic>.from(response.data ?? <String, dynamic>{});
  }

}