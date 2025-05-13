import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/bloc/cubits/currency_cubit/currency_cubit.dart';
import 'package:golden_price/core/bloc/cubits/golden_cubit/gold_price_cubit.dart';
import 'package:golden_price/core/constants/cons.dart';
import 'package:golden_price/core/rest/network_interceptor.dart';
import 'package:golden_price/core/rest/rest_config.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

final locator = GetIt.instance;

class Injection {
  late RestConfig _restApi;
  late RestConfig2 _restApi2;
  late Dio _dio;
  late Dio _dio2;
  Alice alice = Alice(
    showNotification: true,
  );
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
    List<Interceptor> interceptors = [];
    if (kDebugMode) {
      _dio.interceptors
        ..add(alice.getDioInterceptor())
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
      _dio2.interceptors
        ..add(alice.getDioInterceptor())
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
    }

    interceptors.add(NetworkInterceptor());
    _dio.interceptors.addAll(interceptors);
    _dio2.interceptors.addAll(interceptors);

    _restApi = RestConfig(_dio);
    _restApi2 = RestConfig2(_dio2);
    locator.registerSingleton<RestConfig>(_restApi);
    locator.registerSingleton<RestConfig2>(_restApi2);
    locator.registerSingleton<RestContract>(RestContract());
    locator.registerSingleton<GoldPriceCubit>(GoldPriceCubit());
    locator.registerSingleton<CurrencyCubit>(CurrencyCubit());
  }
}
