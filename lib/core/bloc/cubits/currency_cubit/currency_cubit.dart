import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_price/core/repositories/currency_repo/currency_repo.dart';

import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final _repo = CurrencyRepo();

  CurrencyCubit() : super(const CurrencyState.initial());

  Future<void> getCurrency(BuildContext context, dynamic date) async {
    try {
      emit(const CurrencyState.initial());
      final price = await _repo.getGoldPrice(context, date);
      emit(CurrencyState.success(price));
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(CurrencyState.error(e.toString()));
    }
  }
}
