import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golden_price/core/models/currency_model/currency_model.dart';
import 'package:golden_price/core/repositories/currency_repo/currency_repo.dart';

part 'currency_state.dart';
part 'currency_cubit.freezed.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final _repo = CurrencyRepo();
  CurrencyCubit() : super(CurrencyState.initial());

  Future<CurrencyModel?> getCurrency(BuildContext context, dynamic date) async {
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
    return null;
  }
}
