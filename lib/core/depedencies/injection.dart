import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/bloc/cubits/saham_top7_cubit/saham_top7_cubit.dart';
import 'package:golden_price/core/rest/network_interceptor.dart';
import 'package:golden_price/core/rest/rest_config.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

final locator = GetIt.instance;

class Injection {
  late RestConfig _restApi;
  late RestConfig2 _restApi2;
  late RestConfigIDX _restApiIDX;
  late Dio _dio;
  late Dio _dio2;
  late Dio _dio3;
  Alice alice = Alice(
    configuration: AliceConfiguration(
      showNotification: true,
    ),
  );
  AliceDioAdapter aliceDioAdapter = AliceDioAdapter();
  final locator = GetIt.instance;

  Injection.init() {
    _initDependencies();
  }

  Future _initDependencies() async {
    if (!kIsWeb) {
      locator.registerSingleton<Alice>(alice);
    }

    _dio = Dio(RestConfig.options());
    _dio2 = Dio(RestConfig2.options());
    _dio3 = Dio(RestConfigIDX.options());
    alice.addAdapter(aliceDioAdapter);
    List<Interceptor> interceptors = [];
    if (kDebugMode) {
      _dio.interceptors
        ..add(aliceDioAdapter)
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
      _dio2.interceptors
        ..add(aliceDioAdapter)
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
      _dio3.interceptors
        ..add(aliceDioAdapter)
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
    }

    interceptors.add(NetworkInterceptor());
    _dio.interceptors.addAll(interceptors);
    _dio2.interceptors.addAll(interceptors);
    _dio3.interceptors.addAll(interceptors);

    _restApi = RestConfig(_dio);
    _restApi2 = RestConfig2(_dio2);
    _restApiIDX = RestConfigIDX(_dio3);
    locator.registerSingleton<RestConfig>(_restApi);
    locator.registerSingleton<RestConfig2>(_restApi2);
    locator.registerSingleton<RestConfigIDX>(_restApiIDX);
    locator.registerSingleton<RestContract>(RestContract());
    locator.registerSingleton<GoldPriceCubit>(GoldPriceCubit());
    locator.registerSingleton<CurrencyCubit>(CurrencyCubit());
    locator.registerSingleton<SahamTop7Cubit>(SahamTop7Cubit());
  }
}
