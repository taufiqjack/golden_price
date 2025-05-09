import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golden_price/core/models/gold_prices_mode/gold_price_mode.dart';
import 'package:golden_price/core/repositories/golden_repo/goldern_repo.dart';

part 'gold_price_state.dart';
part 'gold_price_cubit.freezed.dart';

class GoldPriceCubit extends Cubit<GoldPriceState> {
  final _repo = GoldenPriceRepository();

  GoldPriceCubit() : super(GoldPriceState.initial());

  Future<GoldPricesModel?> getGoldPrice(BuildContext context) async {
    try {
      emit(const GoldPriceState.initial());
      final price = await _repo.getGoldPrice(context);
      emit(GoldPriceState.success(price));
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(GoldPriceState.error(e.toString()));
    }
    return null;
  }
}
