import 'package:dio/dio.dart';

class InterceptorWrapper extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('###### Request Log ######');
    print('url ${options.uri}');
    print('method ${options.method}');
    print('data ${options.data}');
    print('headers  ${options.headers}');
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('###### On Error ######');
    print('error: ${err.response}');
  }
}
