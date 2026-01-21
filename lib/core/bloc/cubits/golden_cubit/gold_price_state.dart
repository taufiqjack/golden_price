import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golden_price/core/models/gold_model/gold_model.dart';
part 'gold_price_state.freezed.dart';

@freezed
class GoldPriceState with _$GoldPriceState {
  const factory GoldPriceState.initial() = _Initial;
  const factory GoldPriceState.error(String message) = _Error;
  const factory GoldPriceState.success(GoldModel? goldPrice) = _Success;
}
