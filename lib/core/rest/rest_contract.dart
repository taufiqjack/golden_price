import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/rest/rest_config.dart';

class RestContract {
  final GetIt _getIt = GetIt.instance;
  late RestConfig _restConfig;
  late RestConfig2 _restConfig2;
  late RestConfigIDX _restConfigIDX;
  late Dio _dio;
  late Dio _dio2;
  late Dio _dio3;

  RestContract() {
    _restConfig = _getIt.get<RestConfig>();
    _dio = _restConfig.dio();
    _restConfig2 = _getIt.get<RestConfig2>();
    _dio2 = _restConfig2.dio();
    _restConfigIDX = _getIt.get<RestConfigIDX>();
    _dio3 = _restConfigIDX.dio();
  }

  Future<Response> goldenPrice() async {
    return await _dio.get(goldPrice);
  }

  Future<Response> getCurrUSID(date) async {
    return await _dio2.get('$currency$date$usd');
  }

  Future<Response> getSahamTop7() async {
    return await _dio3.get(
      '$top7?resultCount=7',
    );
  }
}
