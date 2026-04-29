import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('GET ${options.uri}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('${response.statusCode} ${response.requestOptions.path}');
            handler.next(response);
          },
          onError: (e, handler) {
            debugPrint('${e.requestOptions.path}: ${e.message}');
            handler.next(e);
          },
        ),
      );
    }

    return dio;
  }
}
