import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golden_price/core/models/currency_model/currency_model.dart';

part 'currency_state.freezed.dart';

@freezed
class CurrencyState with _$CurrencyState {
  const factory CurrencyState.initial() = _Initial;
  const factory CurrencyState.error(String message) = _Error;
  const factory CurrencyState.success(CurrencyModel? currency) = _Success;
}
