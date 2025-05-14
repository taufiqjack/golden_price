import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:golden_price/core/constants/cons.dart';

class RestConfig {
  static BaseOptions options() => BaseOptions(
        baseUrl: '${dotenv.env[baseURL]}',
        sendTimeout: const Duration(hours: 24),
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 100000),
        followRedirects: false,
        validateStatus: (status) => true,
      );
  final Dio _dio;
  RestConfig(this._dio);

  Dio dio() {
    return _dio;
  }
}

class RestConfig2 {
  static BaseOptions options() => BaseOptions(
        baseUrl: '${dotenv.env[baseURLCurr]}',
        sendTimeout: const Duration(hours: 24),
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 100000),
        followRedirects: false,
        validateStatus: (status) => true,
      );
  final Dio _dio;
  RestConfig2(this._dio);

  Dio dio() {
    return _dio;
  }
}

class RestConfigIDX {
  static BaseOptions options() => BaseOptions(
        baseUrl: '${dotenv.env[baseURLIDX]}',
        sendTimeout: const Duration(hours: 24),
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 100000),
        followRedirects: false,
        validateStatus: (status) => true,
      );
  final Dio _dio;
  RestConfigIDX(this._dio);

  Dio dio() {
    return _dio;
  }
}
