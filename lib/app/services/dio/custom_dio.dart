import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class CustomDio {
  CustomDio._() {
    _dio = Dio(options);
  }

  late Dio _dio;
  static CustomDio? _simpleInstance;

  final options = BaseOptions(
    baseUrl: dotenv.env['base_url'].toString(),
    connectTimeout: int.parse(dotenv.env['dio_connectTimeout'].toString()),
    receiveTimeout: int.parse(dotenv.env['dio_receiveTimeout'].toString()),
  );

  static Dio get instance {
    _simpleInstance ??= CustomDio._();
    return _simpleInstance!._dio;
  }
}
