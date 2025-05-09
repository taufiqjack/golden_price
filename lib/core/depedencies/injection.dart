import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_price/core/bloc/cubits/cubit/gold_price_cubit.dart';
import 'package:golden_price/core/rest/network_interceptor.dart';
import 'package:golden_price/core/rest/rest_config.dart';
import 'package:golden_price/core/rest/rest_contract.dart';

final locator = GetIt.instance;

class Injection {
  late RestConfig _restApi;
  late Dio _dio;
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
    List<Interceptor> interceptors = [];
    if (kDebugMode) {
      _dio.interceptors
        ..add(alice.getDioInterceptor())
        ..add(LogInterceptor(
          requestBody: true,
          responseBody: true,
        ));
    }

    interceptors.add(NetworkInterceptor());
    _dio.interceptors.addAll(interceptors);

    _restApi = RestConfig(_dio);
    locator.registerSingleton<RestConfig>(_restApi);
    locator.registerSingleton<RestContract>(RestContract());
    locator.registerSingleton<GoldPriceCubit>(GoldPriceCubit());
  }
}
