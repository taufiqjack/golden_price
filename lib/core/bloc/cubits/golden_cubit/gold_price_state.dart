part of 'gold_price_cubit.dart';

@freezed
class GoldPriceState with _$GoldPriceState {
  const factory GoldPriceState.initial() = _Initial;
  const factory GoldPriceState.error(String message) = _Error;
  const factory GoldPriceState.success(GoldPricesModel? goldPrice) = _Success;
}
