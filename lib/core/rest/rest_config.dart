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
        headers: {
          'Accept': 'application/json, text/plain, */*',
        },
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

class RestConfigYahoo {
  static BaseOptions options() => BaseOptions(
        baseUrl: yahooBaseUrl,
        // Yahoo rejects requests without a browser-like user agent.
        headers: {'User-Agent': 'Mozilla/5.0'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => true,
      );
  final Dio _dio;
  RestConfigYahoo(this._dio);

  Dio dio() {
    return _dio;
  }
}
