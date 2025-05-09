import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/rest/rest_config.dart';

class RestContract {
  final GetIt _getIt = GetIt.instance;
  late RestConfig _restConfig;
  late Dio _dio;

  RestContract() {
    _restConfig = _getIt.get<RestConfig>();
    _dio = _restConfig.dio();
  }

  Future<Response> goldenPrice() async {
    return await _dio.get(goldPrice);
  }
}
